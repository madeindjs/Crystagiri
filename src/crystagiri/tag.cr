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

    def parent : Tag | Nil
      if parent = @node.parent
        return Tag.new parent
      end
      nil
    end

    def children : Array(Tag)
      children = [] of Tag
      @node.children.each do |node|
        if node.element?
          children << Tag.new node
        end
      end
      children
    end

    def has_class?(klass : String) : Bool
      if classes = classname
        return classes.includes?(klass)
      end
      false
    end
  end
end
