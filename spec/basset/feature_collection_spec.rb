require File.dirname(__FILE__) + '/../spec_helper'

describe "feature collection" do
  describe "numbering features" do
    before(:each) do
      @collection = Basset::FeatureCollection.new
      @collection.add_row %w[hello paul hello]
    end

    it "takes rows of features" do
      @collection.features.should == %w[hello paul]
    end

    it "counts how many rows have been added" do
      @collection.row_count.should == 1
    end

    it "counts the number of unique features" do
      @collection.feature_count.should == 2
    end

    it "keeps the index of a feature" do
      @collection.index_of("hello").should == 0
      @collection.index_of("paul").should == 1
    end

    it "returns nil as the index for a feature not in the collection" do
      @collection.index_of("whatevs").should == nil
    end

    it "knows the number of rows a feature occurs in" do
      @collection.add_row %w[code hello paul and paul]
      @collection.document_frequency("code").should == 1
      @collection.document_frequency("hello").should == 2
      @collection.document_frequency("paul").should == 2
    end

    it "should remove features that occur under a given number of times and renumber all others while preserving insertion order" do
      collection = Basset::FeatureCollection.new
      collection.add_row %w[hello basset library hello library]
      collection.add_row %w[basset is sweet hello]
      collection.purge_features_occuring_less_than(2)
      collection.features.size.should == 2
      collection.index_of("hello").should == 0
      collection.index_of("basset").should == 1
    end
  end

  describe "extracing feature vectors" do
    before(:each) do
      @collection = Basset::FeatureCollection.new()
      @collection.add_row %w[hello paul basset]
      @collection.add_row %w[basset is a ruby library]
    end

    it "can return a regular array with feature counts" do
      @collection.features_to_vector(%w[basset is written by paul is]).should == [0, 1, 1, 2, 0, 0, 0]
    end

    it "can extract a sparse vector format" do
      @collection.features_to_sparse_vector(%w[basset is written by paul is library]).should == [[1,1], [2,1], [3,2], [6,1]]
    end

    it "can return a sparse vector with tf counts" do
      @collection.features_to_sparse_vector(%w[basset is written by paul is library], :value => :tf).inspect.should == [[1, 0.142857142857143], [2, 0.142857142857143], [3, 0.285714285714286], [6, 0.142857142857143]].inspect
    end

    it "can return a sparse vector with tf-idf counts" do
      @collection.features_to_sparse_vector(%w[basset is written by paul is library], :value => :tf_idf).inspect.should == [[1, 0.0430042850948545], [2, 0.0], [3, 0.0860085701897089], [6, 0.0430042850948545]].inspect
    end
  end

  describe "serializin a feature collection" do
    it "can serialize to json" do
      collection = Basset::FeatureCollection.new
      collection.add_row %w[hello paul]
      collection.add_row %w[basset by paul]
      JSON.parse(collection.to_json).should == {
        "row_count" => 2,
        "feature_map" => {
          "hello" => [0, 1],
          "paul" => [1, 2],
          "basset" => [2, 1],
          "by" => [3, 1]
        }
      }
    end

    it "can marshall from json" do
      collection = Basset::FeatureCollection.new
      collection.add_row %w[paul hello paul]
      collection.add_row %w[basset by paul]

      marshalled_collection = Basset::FeatureCollection.from_json(collection.to_json)
      marshalled_collection.document_frequency("paul").should == 2
      marshalled_collection.index_of("by").should == 3
    end
  end
end
