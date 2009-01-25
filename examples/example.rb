require File.dirname(__FILE__) + '/../lib/basset.rb'

documents = [
  Basset::Document.new("ruby is awesome", :ruby),
  Basset::Document.new("python is good", :python),
  Basset::Document.new("ruby is fun", :ruby),
  Basset::Document.new("python is boring", :python)]

# first add the docs to the feature selector
# The feature selector is tricky. It messes with this kind of toy example since it throws
# out features that don't occur in enough documents.
feature_selector = Basset::FeatureSelector.new
documents.each {|doc| feature_selector.add_document(doc)}

# now create a feature extractor, which expects an array of features on init. This comes
# from the feature selector
feature_extractor = Basset::FeatureExtractor.new(feature_selector.best_features)

# now we're ready to set up the classifier
naive_bayes = Basset::NaiveBayes.new
documents.each {|doc| naive_bayes.add_document(doc.classification, feature_extractor.extract_numbered(doc))}

test_doc = Basset::Document.new("I like ruby")
puts naive_bayes.classify(test_doc.vector_of_features).inspect
