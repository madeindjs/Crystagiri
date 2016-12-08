require "./spec_helper"

describe Crystagiri::Tag do
  it "should instanciate a Tag object" do
    doc = Crystagiri::HTML.from_file "README.md"
    doc.where_tag("strong") { |tag|
      tag.should be_a Crystagiri::Tag
      tag.node.should be_a XML::Node
    }
  end
end
