require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Document do
  it "should remove punctuation from words" do
    Document.new("abc.").vector_of_features.should == [Feature.new("abc", 1)]
  end
  
  it "should remove numbers from words" do
    Document.new("abc1").vector_of_features.should == [Feature.new("abc", 1)]
  end
  
  it "should remove symbols from words" do
    Document.new("abc%").vector_of_features.should == [Feature.new("abc", 1)]
  end
  
  it "should lowercase text" do
    Document.new("ABC").vector_of_features.should == [Feature.new("abc", 1)]
  end
  
  it "should stem words" do
    Document.new("testing").vector_of_features.should == [Feature.new("test", 1)]
  end
  
  it "should count feature occurances" do
    Document.new("test doc test", :test).vector_of_features.should == 
      [Feature.new("doc", 1), Feature.new("test", 2)]
  end
end