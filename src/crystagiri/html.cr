require "http/client"
require "xml"

module Crystagiri
  # Represent an Html document who can be parsed
  class HTML
    getter :content
    getter :nodes

    # Initialize an Html object from Html source fetched
    # from the url
    def self.from_url(url : String, follow : Bool = false) : HTML
      begin
        response = HTTP::Client.get url
        if response.status_code == 200
          return HTML.new response.body
        elsif follow && response.status_code == 301
          from_url response.headers["Location"], follow: true
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

      @ids = Hash(String, XML::Node).new
      @tags = Hash(String, Array(XML::Node)).new
      @classes = Hash(String, Array(XML::Node)).new

      visit @nodes  # Build internal pointer map
    end

    # Functions used to populate internal maps

    private def add_id(id : String, node : XML::Node)
      @ids[id] = node
    end

    private def add_node(node : XML::Node)
      if @tags[node.name]? == nil
        @tags[node.name] = [] of XML::Node
      end
      @tags[node.name] << node
    end

    private def add_class(klass : String, node : XML::Node)
      if @classes[klass]? == nil
        @classes[klass] = [] of XML::Node
      end
      @classes[klass] << node
    end

    # Depth-first visit. Given a node, extract metadata from
    # node (if exists), then visit each child.
    private def visit(node : XML::Node)
      # We only extract metadata from HTML nodes
      if node.element?
        add_node node 
        if to = node["id"]?
          add_id to, node
        end
        if classes = node["class"]?
          classes.split(' ') { |to| add_class to, node }
        end
      end
      # visit each child
      node.children.each do | child |
        visit child
      end
    end

    # Find first tag by tag name and return
    # `Crystagiri::Tag` founded or a nil if not founded
    def at_tag(tag_name : String) : Crystagiri::Tag | Nil
      if tags = @tags[tag_name]?
        tags.each do |tag|
          return Tag.new(tag).as Crystagiri::Tag
        end
      end
      return nil
    end

    # Find all nodes by tag name and yield
    # `Crystagiri::Tag` founded
    def where_tag(tag_name : String, &block) : Array(Tag)
      arr = [] of Crystagiri::Tag
      if tags = @tags[tag_name]?
        tags.each do |node|
          tag = Tag.new(node).as Crystagiri::Tag
          yield tag
          arr << tag
        end
      end
      return arr
    end

    # Find all nodes by classname and yield
    # `Crystagiri::Tag` founded
    def where_class(class_name : String, &block) : Array(Tag)
      arr = [] of Crystagiri::Tag
      if klasses = @classes[class_name]?
        klasses.each do |node|
          klass = Tag.new(node).as Crystagiri::Tag
          yield klass
          arr << klass
        end
      end
      return arr
    end

    # Find a node by its id and return a
    # `Crystagiri::Tag` founded or a nil if not founded
    def at_id(id_name : String) : Crystagiri::Tag | Nil
      if node = @ids[id_name]?
        return Tag.new(node).as Crystagiri::Tag
      end
    end

    # Find all node corresponding to the css query and yield
    # `Crystagiri::Tag` founded or a nil if not founded
    def css(query : String) : Array(Tag)
      query = HTML.css_query_to_xpath(query)
      return @nodes.xpath_nodes("//#{query}").map { |node|
        tag = Tag.new(node).as(Crystagiri::Tag)
        yield tag
        tag
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
