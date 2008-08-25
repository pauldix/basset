require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe DataVector do
  before(:all) do
    @features = [Feature.new(:foo, 1.5), Feature.new(:bar, 3.7)]
  end
  
  it "should initialize with an array of features" do
    DataVector.new(@features).features.should == @features
  end
  
  it "should convert features to a unit vector" do
    data_vector = DataVector.new(@features)
    data_vector.convert_to_unit
    data_vector.length.should == 1.0
  end
end