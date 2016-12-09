require "http/client"
require "xml"

module Crystagiri
  # Represent an Html document who can be parsed
  class HTML
    getter :content

    # Initialize an Html object from Html source fetched
    # from the url
    def self.from_url(url : String) : HTML
      begin
        response = HTTP::Client.get url
        if response.status_code == 200
          return HTML.new response.body
        else
          raise ArgumentError.new "Host returned #{response.status_code}"
        end
      rescue Socket::Error
        raise Socket::Error.new "Host #{url} cannot be fetched"
      end
    end

    # Initialize an Html object from content of file
    # designed by the given filepath
    def self.from_file(path : String) : HTML
      return HTML.new File.read(path)
    end

    # Transform the css query into an xpath query
    def self.css_query_to_xpath(query : String) : String
      query = "//#{query}"
      # Convert '#id_name' as '[@id="id_name"]'
      query = query.gsub /\#([A-z0-9]+-*_*)+/ { |m| "*[@id=\"%s\"]" % m.delete('#') }
      # Convert '.classname' as '[@class="classname"]'
      query = query.gsub /\.([A-z0-9]+-*_*)+/ { |m| "[@class=\"%s\"]" % m.delete('.') }
      # Convert ' > ' as '/'
      query = query.gsub /\s*>\s*/ { |m| "/" }
      # Convert ' ' as '//'
      query = query.gsub " ", "//"
      # a leading '*' when xpath does not include node name
      query = query.gsub /\/\[/ { |m| "/*[" }
      return query
    end

    # Initialize an Html object from Html source
    def initialize(@content : String)
      @nodes = XML.parse_html @content
    end

    # Find first tag by tag name and return
    # `Crystagiri::Tag` founded or a nil if not founded
    def at_tag(tag_name : String) : Crystagiri::Tag | Nil
      where_tag(tag_name) { |tag| return tag }
      return nil
    end

    # Find all nodes by tag name and yield
    # `Crystagiri::Tag` founded
    def where_tag(tag_name : String, &block)
      css(tag_name) { |tag| yield tag }
    end

    # Find all nodes by classname and yield
    # `Crystagiri::Tag` founded
    def where_class(class_name : String, &block)
      css(".#{class_name}") { |tag| yield tag }
    end

    # Find a node by its id and return a
    # `Crystagiri::Tag` founded or a nil if not founded
    def at_id(id_name : String)
      css("##{id_name}") { |tag| return tag }
    end

    # Find all node corresponding to the css query and yield
    # `Crystagiri::Tag` founded or a nil if not founded
    def css(query : String, &block)
      query = HTML.css_query_to_xpath(query)
      @nodes.xpath_nodes("//#{query}").each { |node|
        yield Tag.new(node).as(Crystagiri::Tag)
      }
    end

    # Find first node corresponding to the css query and return
    # `Crystagiri::Tag` if founded or a nil if not founded
    def at_css(query : String)
      css(query) { |tag| return tag }
      return nil
    end
  end
end
