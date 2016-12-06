require "http/client"

module Cristagiri
  # Represent an Html document who can be parsed
  class HTML
    getter :content

    # Initialize an Html object from Html source fetched
    # from the url
    def self.from_url(url : String) : HTML
      response = HTTP::Client.get url
      if response.status_code == 200
        return HTML.new response.body
      else
        raise ArgumentError.new "Host returned #{response.status_code}"
      end
    end

    # Initialize an Html object from content of file
    # designed by the given filepath
    def self.from_file(path : String) : HTML
      return HTML.new File.read(path)
    end

    # Transform the css query into an xpath query
    def self.css_query_to_xpath(query : String) : String
      query = query.gsub /.[A-z]+-*_*[A-z]+/ { |m| "[@class=\"#{m}\"]" }
      query = query.delete '.'
      return "//#{query}"
    end

    # Initialize an Html object from Html source
    def initialize(@content : String)
      @nodes = XML.parse_html @content
    end

    # Find all nodes by tag name and yield
    # [XML::Node](https://crystal-lang.org/api/0.20.1/XML/Node.html)
    # founded
    def tag(tag : String, &block)
      @nodes.xpath_nodes("//#{tag}").each do |tag|
        yield tag
      end
    end

    # Find all nodes by classname and yield
    # [XML::Node](https://crystal-lang.org/api/0.20.1/XML/Node.html)
    # founded
    def class(classname : String, &block)
      @nodes.xpath_nodes("//*[@class=\"#{classname}\"]").each do |tag|
        yield tag
      end
    end

    # Find a node by its id and return a
    # [XML::Node](https://crystal-lang.org/api/0.20.1/XML/Node.html)
    # founded or a nil if not founded
    def at_id(id_name : String)
      return @nodes.xpath_node "//*[@id=\"#{id_name}\"]"
    end

    # Find all node corresponding to the css query and yield
    # [XML::Node](https://crystal-lang.org/api/0.20.1/XML/Node.html)
    # if founded or a nil if not founded
    def css(query : String, &block)
      query = HTML.css_query_to_xpath(query)
      @nodes.xpath_nodes("//#{query}").each do |tag|
        yield tag
      end
    end

    # Find first node corresponding to the css query and return
    # [XML::Node](https://crystal-lang.org/api/0.20.1/XML/Node.html)
    # if founded or a nil if not founded
    def at_css(query : String)
      css(query) { |node| return node }
      return nil
    end
  end
end
