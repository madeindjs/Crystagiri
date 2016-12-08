module Crystagiri
  class Tag
    getter :node

    def initialize(node : XML::Node)
      @node = node
    end
  end
end
