require File.join(File.dirname(__FILE__), "yaml_serialization")

module Basset
  
  # Extracts features from a document. On initialization it expects the set of features that 
  # are to be extracted from documents. The extracted features will just be numbered in 
  # ascending order. This makes it easy to output feature sets for libraries like svmlight.
  class FeatureExtractor
    include YamlSerialization
    
    # the constructor takes an array of feature names. These are the features that will be
    # extracted from documents. All others will be ignored.
    def initialize(feature_names)
      @feature_names = {}
      feature_names.each_with_index {|feature_name, index| @feature_names[feature_name] = index + 1}
    end
  
    def number_of_features
      @feature_names.size
    end

    # returns an array of features, but with their names replaced with an integer identifier.
    # They should be sorted in ascending identifier order. This is a generic representation that works
    # well with other machine learning packages like svm_light.
    def extract_numbered(document)
      numbered_features = extract(document).collect do |feature|
        Feature.new(@feature_names[feature.name], feature.value)
      end
      numbered_features.sort
    end
  
    # just returns the features from the document that the extractor is interested in
    def extract(document)
      document.vector_of_features.find_all do |feature|
        @feature_names[feature.name]
      end
    end
  
    # def extract_with_duplicate_removal(document)
    #   features = extract(document)
    #   # # now remove the unigrams that dupe bigram features
    #   # # first grab an array of the bigram ones
    #   # bigram_features = []
    #   # sorted_features.each {|feature| bigram_features << feature if feature.name =~ /.*_AND_.*/}
    #   # # now remove all the ones that have a match in the bigram features
    #   # sorted_features.each_with_index do |feature, index|
    #   #   sorted_features.delete_at(index) if (feature.name !~ /_AND_/ and bigram_features.detect {|bf| bf.name =~ /^#{feature.name}_|_#{feature.name}$/})
    #   # end
    # end
    
  end
end