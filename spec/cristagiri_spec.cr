require "./spec_helper"

describe Cristagiri do
  it "should have a version number" do
    Cristagiri::VERSION.should_not be_nil
  end

  it "should instanciate an HTML object" do
    doc = Cristagiri::HTML.new "<h1>Hello</h1>"
    doc.should_not be_nil
  end

  it "should instanciate an HTML object from a given filepath" do
    doc = Cristagiri::HTML.from_file "README.md"
    doc.should be_a Cristagiri::HTML
    doc.content.should_not eq ""
  end

  it "should instanciate an HTML object from a file" do
    doc = Cristagiri::HTML.from_url "http://example.com/"
    doc.should be_a Cristagiri::HTML
    doc.content.should_not eq ""
  end

  it "should parse local document" do
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.should be_a Cristagiri::HTML
    doc.content.should_not eq ""
    # Count number of tags founded
    {"body" => 1, "h2" => 6, "strong" => 10}.each do |tag, qty|
      nb_tag = 0
      doc.tag(tag) { |i| nb_tag += 1 }
      nb_tag.should eq qty
    end
  end
end
