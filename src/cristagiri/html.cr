require "http/client"

module Cristagiri
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
  end
end
