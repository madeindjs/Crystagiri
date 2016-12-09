require "./spec_helper"

describe Crystagiri::HTML do
  it "should instanciate an HTML object" do
    doc = Crystagiri::HTML.new "<h1>Hello</h1>"
    doc.should_not be_nil
  end

  it "should instanciate an HTML object from a given filepath" do
    doc = Crystagiri::HTML.from_file "README.md"
    doc.should be_a Crystagiri::HTML
    doc.content.should_not eq ""
  end

  it "should instanciate an HTML object from a website url" do
    doc = Crystagiri::HTML.from_url "http://example.com/"
    doc.should be_a Crystagiri::HTML
    doc.content.should_not eq ""
  end

  it "should find nodes by tag name" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.should be_a Crystagiri::HTML
    # Count number of tags founded
    {"body" => 1, "h2" => 2, "strong" => 8}.each do |tag, qty|
      nb_tag = 0
      doc.where_tag(tag) { |i| nb_tag += 1 }
      nb_tag.should eq qty
    end
  end

  it "should find by classname name" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    # Count number of tags founded
    {"step-title" => 8, "introduction" => 2, "steps" => 2}.each do |classname, qty|
      nb_tag = 0
      doc.where_class(classname) { |i| nb_tag += 1 }
      nb_tag.should eq qty
    end
  end

  it "should find by id" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_id("main-content").should be_a Crystagiri::Tag
  end

  it "should find 'tag+classname' by css query" do
    Crystagiri::HTML.css_query_to_xpath("a.method-permalink").should eq "//a[@class=\"method-permalink\"]"
    Crystagiri::HTML.css_query_to_xpath("strong.step-title").should eq "//strong[@class=\"step-title\"]"
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css("strong.step-title").should be_a Crystagiri::Tag
  end

  it "should find 'id' by css query" do
    # test query converter
    css_query = "#main-content"
    xpath_query = "//*[@id=\"main-content\"]"
    Crystagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_a Crystagiri::Tag
  end

  it "should find 'id' by css query" do
    # test query converter
    css_query = "#main-content"
    xpath_query = "//*[@id=\"main-content\"]"
    Crystagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_a Crystagiri::Tag
  end

  it "should find subtags like 'id tag.class' by css query" do
    # test query converter
    css_query = "#main-content ol.steps"
    xpath_query = "//*[@id=\"main-content\"]//ol[@class=\"steps\"]"
    Crystagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_a Crystagiri::Tag
    #
    # another test
    css_query = "ol.steps strong.step-title"
    xpath_query = "//ol[@class=\"steps\"]//strong[@class=\"step-title\"]"
    Crystagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    doc.at_css(css_query).should be_a Crystagiri::Tag
  end

  it "should find only first subtags like 'id > tag.class' by css query" do
    # test query converter
    css_query = "#main-content > strong.step-title"
    xpath_query = "//*[@id=\"main-content\"]/strong[@class=\"step-title\"]"
    Crystagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    # test on local file
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(css_query).should be_nil
    #
    # another test
    css_query = "body>quote.introduction"
    xpath_query = "//body/quote[@class=\"introduction\"]"
    Crystagiri::HTML.css_query_to_xpath(css_query).should eq xpath_query
    doc.at_css(css_query).should be_a Crystagiri::Tag
  end

  it "should find a class with number" do
    doc = Crystagiri::HTML.from_file "spec/fixture/HTML.html"
    doc.at_css(".title69").should be_a Crystagiri::Tag
    doc.css("#ctl00_ContentPlaceHolder_LblRecetteNombre") { |tag|
      tag.content.should eq "4 pers"
    }
  end

  it "should pass bulletprrof property name" do
    Crystagiri::HTML.css_query_to_xpath("strong #Az_xA--az.--").should eq "//strong//*[@id=\"Az_xA--az\"].--"
  end
end
