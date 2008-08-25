require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe TrainingVector do
  it "should initialize with a class and an array of features" do
    features = [Feature.new(:foo, 1.5), Feature.new(:bar, 3.7)]
    training_vector = TrainingVector.new(:interesting, features)
    training_vector.classification.should == :interesting
    training_vector.features.should == features
  end
end