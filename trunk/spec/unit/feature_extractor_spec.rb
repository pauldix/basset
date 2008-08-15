require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe FeatureExtractor do
  DocumentMock = Struct.new(:vector_of_features)

  it "should save to file"
  it "should be loadable from file"
  
  it "should return number of features" do
    FeatureExtractor.new(%w[one two]).number_of_features.should == 2 
  end
  
  it "should throw away extra features" do
    doc = DocumentMock.new([Feature.new("keep"), Feature.new("throwaway")])
    FeatureExtractor.new(%w[keep]).extract(doc).should == [Feature.new("keep")]
  end
  
  it "should extract no features from a doc with no features" do
    FeatureExtractor.new(%w[keep]).extract(DocumentMock.new([])).should == []
  end
  
  it "should extract numbered features" do
    doc = DocumentMock.new([Feature.new("keep", 0)])
    FeatureExtractor.new(%w[keep]).extract_numbered(doc).should == [Feature.new(1, 0)]
  end
  
  it "should sort extracted numbered features" do
    feature_extractor = FeatureExtractor.new(%w[keep1 keep2])
    doc = DocumentMock.new([Feature.new("keep2", 10), Feature.new("keep1", 20)])
    feature_extractor.extract_numbered(doc).should == [Feature.new(1, 20), Feature.new(2, 10)]
  end
end