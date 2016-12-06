require "./spec_helper"

describe Cristagiri do
  it "should have a version number" do
    Cristagiri::VERSION.should_not be_nil
  end

  it "should instanciate an HTML object" do
    Cristagiri::HTML.new("https://google.com").should_not be_nil
  end
end
