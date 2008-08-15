require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Feature do
  it "should store name" do
    Feature.new("hello").name.should == "hello"
  end
  
  it "should require name" do
    lambda { Feature.new }.should raise_error(ArgumentError)
  end
  
  it "should store values" do
    Feature.new("name", 2).value.should ==2 
  end

  it "should default value to zero" do
    Feature.new("name").value.should == 0
  end
  
  it "should be equal with same name and no value" do
    Feature.new("hello").should == Feature.new("hello")
  end
  
  it "should be equal with same name and same value" do
    Feature.new("hello", 1).should == Feature.new("hello", 1)
  end
  
  it "should not be equal with different name" do
    Feature.new("hello").should_not == Feature.new("test")
  end
  
  it "should not be equal with same name and different value" do
    Feature.new("hello", 1).should_not == Feature.new("hello", 2)
  end
  
  it "should sort by name ascending then value ascending" do
    [Feature.new("b", 3), Feature.new("a", 2), Feature.new("a", 1)].sort.should ==
    [Feature.new("a", 1), Feature.new("a", 2), Feature.new("b", 3)]
  end
end