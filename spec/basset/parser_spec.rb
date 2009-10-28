require File.dirname(__FILE__) + '/../spec_helper'

describe "parsing" do
  it "should parse out punctuation" do
    Basset::Parser.parse("hello! there").should == %w[hello there]
  end
  
  it "should parse out numbers" do
    Basset::Parser.parse("this 234 number3").should == %w[this number]
  end
  
  it "should optionally return bigrams" do
    Basset::Parser.parse("hi there paul", :ngrams => 2).should == %w[hi there paul hi_there there_paul]
  end
  
  it "should downcase everything" do
    Basset::Parser.parse("HelLo").should == %w[hello]
  end
end
