require File.dirname(__FILE__) + '/../spec_helper'

describe "feature collection" do
  describe "numbering features" do
    it "takes rows of features" do
      @collection = Basset::FeatureCollection.new
      @collection.add_row %w[hello paul]
      @collection.features.should == %w[hello paul]
    end
    
    it "keeps the index of a feature" do
      @collection = Basset::FeatureCollection.new
      @collection.add_row %w[hello paul]
      @collection.index_of("hello").should == 0
      @collection.index_of("paul").should == 1
    end
    
    it "returns nil as the index for a feature not in the collection" do
      @collection = Basset::FeatureCollection.new
      @collection.add_row %w[hello paul]
      @collection.index_of("whatevs").should == nil
    end
    
    it "knows the number of times a feature occurs across all rows" do
      @collection = Basset::FeatureCollection.new
      @collection.add_row %w[hello paul]
      @collection.add_row %w[code hello paul and paul]
      @collection.global_frequency("hello").should == 2
      @collection.global_frequency("paul").should == 3
    end
  end
  
  describe "extracing feature vectors" do
    before(:all) do
      @collection = Basset::FeatureCollection.new()
      @collection.add_row %w[hello paul]
      @collection.add_row %w[basset is a ruby library]
    end
    
    it "can return a regular array with feature counts" do
      @collection.features_to_vector(%w[basset is written by paul is]).should == [0, 1, 1, 2, 0, 0, 0]
    end
    
    it "can extract a sparse vector format" do
      @collection.features_to_sparse_vector(%w[basset is written by paul is library]).should == ["1,1", "2,1", "3,2", "6,1"]
    end
  end
  
  describe "normalization" do
    
  end
end
