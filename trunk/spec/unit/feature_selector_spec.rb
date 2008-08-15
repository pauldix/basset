require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe FeatureSelector do
  DocumentMock = Struct.new(:vector_of_features, :classification)

  it "should count documents" do
    feature_selector = FeatureSelector.new
    feature_selector.docs.should == 0
    feature_selector.add_document(DocumentMock.new([]))
    feature_selector.docs.should == 1
  end

  it "should return all feature names" do
    feature_selector = FeatureSelector.new
    feature_selector.all_feature_names.should == []
    feature_selector.add_document(DocumentMock.new([Feature.new("a")]))
    feature_selector.add_document(DocumentMock.new([Feature.new("b")]))
    feature_selector.all_feature_names.should == %w[a b]
  end

  # TODO
  # it "should return_all_features_as_best    
  #   feature_selector = FeatureSelector.new
  #   feature_selector.add_document(DocumentMock.new([Feature.new("a")], :test))
  #   assert_equal %w[a], feature_selector.best_features_for_classification(:test, 10)
  # end

  it "should count docs with feature and class" do
    feature_selector = FeatureSelector.new
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("puppy", 1)], :ham))
    feature_selector.docs_with_feature_and_class("viagra", :spam).should == 1
    feature_selector.docs_with_feature_and_class("viagra", :ham).should == 0
  end

  it "should count docs with feature and not class" do
    feature_selector = FeatureSelector.new
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("puppy", 1)], :ham))
    feature_selector.docs_with_feature_and_not_class("puppy", :spam).should == 1
    feature_selector.docs_with_feature_and_not_class("puppy", :ham).should == 0
  end

  it "should count docs with class and not feature" do
    feature_selector = FeatureSelector.new
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("puppy", 1)], :ham))
    feature_selector.docs_with_class_and_not_feature(:spam, "puppy").should == 1
    feature_selector.docs_with_class_and_not_feature(:spam, "viagra").should == 0
  end

  it "should count docs without feature or class" do
    feature_selector = FeatureSelector.new
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("puppy", 1)], :ham))
    feature_selector.docs_without_feature_or_class("viagra", :spam).should == 1
    feature_selector.docs_without_feature_or_class("viagra", :ham).should == 0
  end

  it "should return zero chi if all docs contain feature" do
    feature_selector = FeatureSelector.new
    the = Feature.new("the", 1)
    feature_selector.add_document(doc([the], :spam))
    feature_selector.add_document(doc([the], :ham))
    feature_selector.features_with_chi(:spam).should == [Feature.new("the", 0.0)]
  end

  it "should compute chi squared" do
    feature_selector = FeatureSelector.new
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("puppy", 1)], :ham))
    feature_selector.features_with_chi(:spam).should == [Feature.new("viagra", 2.0), Feature.new("puppy", 2.0)]
  end

  it "should not select any features if they are all insignificant" do
    feature_selector = FeatureSelector.new
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("puppy", 1)], :ham))
    feature_selector.select_features.should == []
  end

  it "should not select features in only one doc" do
    feature_selector = FeatureSelector.new
    the = Feature.new("the", 1)
    feature_selector.add_document(doc([the, Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([the, Feature.new("puppy", 1)], :ham))
    feature_selector.select_features.should == []
  end

  it "should select significant features occuring in more than one doc" do
    feature_selector = FeatureSelector.new
    the = Feature.new("the", 1)
    feature_selector.add_document(doc([the, Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([Feature.new("viagra", 1)], :spam))
    feature_selector.add_document(doc([the, Feature.new("puppy", 1)], :ham))
    feature_selector.select_features.should == %w[viagra]
  end

  it "should return selected features sorted by chi squared descending"
  it "should select based on first feature by default"
  it "should select with a chi squared of 1 by default"

private

  def doc(*args)
    DocumentMock.new(*args)
  end
end