require "./spec_helper"

describe Crystagiri::Tag do
  it "should instanciate a Tag object" do
    doc = Crystagiri::HTML.from_file "README.md"
    doc.where_tag("strong") { |tag|
      tag.should be_a Crystagiri::Tag
      tag.node.should be_a XML::Node
    }
  end

  it "should instanciate a Tag object" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    # Check data for first strong tag
    tag = doc.at_tag("strong").as(Crystagiri::Tag)
    tag.content.should eq "Clone"
    tag.tagname.should eq "strong"
    tag.classname.should eq "step-title"
    # Check data for an another tag
    tag = doc.at_tag("h1").as(Crystagiri::Tag)
    tag.content.should eq "Crystagiri"
    tag.tagname.should eq "h1"
    tag.classname.should eq nil
  end
end
