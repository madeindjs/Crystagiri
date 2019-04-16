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

  it "can browse document using only Tag objects: parents" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    tag = doc.at_tag("strong").as(Crystagiri::Tag)

    parent = tag.parent.as(Crystagiri::Tag)
    parent.should_not be nil
    parent.tagname.should eq "li"

    pparent = parent.parent.as(Crystagiri::Tag)
    pparent.tagname.should eq "ol"
    pparent.classname.should eq "steps"
  end

  it "can browse document using only Tag objects: children" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    tag = doc.at_id("main-content").as(Crystagiri::Tag)

    children = tag.children.as(Array(Crystagiri::Tag))
    children.size.should eq 5

    children.each do |child|
      child.should be_a Crystagiri::Tag
    end

    h2 = children[0]
    h2.tagname.should eq "h2"
    h2.content.should eq "Developement"

    h2.children.should eq [] of Crystagiri::Tag

    ol = children[3]
    li = ol.children[0]
    strong = li.children[0]
    a = strong.children[0]

    a.should be_a Crystagiri::Tag
    a.tagname.should eq "a"
    a.content.should eq "Fork it"
  end

  it "can detect wether a tag has a particular class" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    tag = doc.at_id("main-content").as(Crystagiri::Tag)

    children = tag.children.as(Array(Crystagiri::Tag))

    ol = children[3]
    li = ol.children[0]
    strong = li.children[0]

    strong.has_class?("step-title").should eq true
    strong.has_class?("first").should eq true
    strong.has_class?("dummy").should eq false
  end
end
