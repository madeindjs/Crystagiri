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

  it "should instanciate an HTML object from a website url" do
    doc = Cristagiri::HTML.from_url "http://example.com/"
    doc.should be_a Cristagiri::HTML
    doc.content.should_not eq ""
  end

  it "should find nodes by tag name" do
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.should be_a Cristagiri::HTML
    # Count number of tags founded
    {"body" => 1, "h2" => 2, "strong" => 8}.each do |tag, qty|
      nb_tag = 0
      doc.tag(tag) { |i| nb_tag += 1 }
      nb_tag.should eq qty
    end
  end

  it "should find by classname name" do
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    # Count number of tags founded
    {"step-title" => 8, "introduction" => 2, "steps" => 2}.each do |classname, qty|
      nb_tag = 0
      doc.class(classname) { |i| nb_tag += 1 }
      nb_tag.should eq qty
    end
  end

  it "should find by id" do
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_id("main-content").should be_a XML::Node
  end

  it "should find 'tag+classname' by css query" do
    Cristagiri::HTML.css_query_to_xpath("a.method-permalink").should eq "//a[@class=\"method-permalink\"]"
    Cristagiri::HTML.css_query_to_xpath("strong.step-title").should eq "//strong[@class=\"step-title\"]"
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css("strong.step-title").should be_a XML::Node
  end

  it "should find 'id' by css query" do
    # test query converter
    css_query = "#main-content"
    xpath_query = "//*[@id=\"main-content\"]"
    Cristagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_a XML::Node
  end

  it "should find 'id' by css query" do
    # test query converter
    css_query = "#main-content"
    xpath_query = "//*[@id=\"main-content\"]"
    Cristagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_a XML::Node
  end

  it "should find subtags like 'id tag.class' by css query" do
    # test query converter
    css_query = "#main-content ol.steps"
    xpath_query = "//*[@id=\"main-content\"]//ol[@class=\"steps\"]"
    Cristagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_a XML::Node
    #
    # another test
    css_query = "ol.steps strong.step-title"
    xpath_query = "//ol[@class=\"steps\"]//strong[@class=\"step-title\"]"
    Cristagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    doc.at_css(css_query).should be_a XML::Node
  end

  it "should find only first subtags like 'id > tag.class' by css query" do
    # test query converter
    css_query = "#main-content > strong.step-title"
    xpath_query = "//*[@id=\"main-content\"]/strong[@class=\"step-title\"]"
    Cristagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Cristagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_nil
    #
    # another test
    css_query = "body>quote.introduction"
    xpath_query = "//body/quote[@class=\"introduction\"]"
    Cristagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    doc.at_css(css_query).should be_a XML::Node
  end
end
