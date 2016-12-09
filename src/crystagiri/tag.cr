module Crystagiri
  class Tag
    getter :node

    def initialize(@node : XML::Node)
    end

    def classname : String | Nil
      return @node["class"]? ? @node["class"] : nil
    end

    def tagname : String
      return @node.name
    end

    def content : String
      return @node.text != nil ? @node.text.as(String) : "".as(String)
    end
  end
end
