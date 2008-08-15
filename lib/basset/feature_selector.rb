module Basset

  # This class is the feature selector. All documents in the training set should be added 
  # to the selector. Once they are in, a number of features may be selected based on the 
  # chi square value. When in doubt just call feature_with_chi_value_greater_than with an 
  # empty hash. It will return all features that have at least some statistical significance 
  # and occur in more than one document.
  class FeatureSelector
    attr_reader :docs
  
    def initialize
      @docs           = 0
      @docs_in_class  = Hash.new(0)
      @features       = Hash.new { |h, k| h[k] = FeatureValues.new }
    end
  
    # Adds a document to the feature selector. The document should respond_to a 
    # method vector_of_features which returns a vector of unique features.
    def add_document(document)
      @docs += 1
      @docs_in_class[document.classification] += 1
      
      document.vector_of_features.each do |feature| 
        @features[feature.name].add_document_with_class(document.classification)
      end
    end
  
    # returns all features, regardless of chi_square or frequency
    def all_feature_names
      @features.keys
    end
    
    def number_of_features
      @features.size
    end
  
    # returns an array of the best features for a given classification    
    def best_features(count = 10, classification = nil)
      select_features(1.0, classification).first(count)
    end
  
    def features_with_chi(classification)
      @features.keys.map do |feature_name|
        Feature.new(feature_name, chi_squared(feature_name, classification))
      end
    end
    
    # returns an array of features that have a minimum or better chi_square value.
    def select_features(chi_value = 1.0, classification = nil)
      classification ||= @docs_in_class.keys.first

      selected_features = features_with_chi(classification).select do |feature|
        (docs_with_feature(feature.name) > 1) && (feature.value >= chi_value)
      end
      
      selected_features.sort_by(&:value).reverse.collect(&:name)
    end
    
  private
    
    def docs_with_feature_and_class(feature_name, classification)
      @features[feature_name].docs_with_class(classification)
    end

    def docs_with_feature_and_not_class(feature_name, classification)
      @features[feature_name].docs_with_feature - @features[feature_name].docs_with_class(classification)
    end

    def docs_with_class_and_not_feature(classification, feature_name)
      @docs_in_class[classification] - @features[feature_name].docs_with_class(classification)
    end

    def docs_without_feature_or_class(feature_name, classification)
      @docs - @docs_in_class[classification] - docs_with_feature_and_not_class(feature_name, classification)
    end

    def docs_with_feature(feature_name)
      @features[feature_name].docs_with_feature
    end
  
    def docs_with_class(classification)
      @docs_in_class[classification]
    end

    # Returns the chi_squared value for this feature with the passed classification
    # This is formula 13.14 on page 215 of An Introduction to Information Retrieval by 
    # Christopher D. Manning, Prabhakar Raghavan and Hinrich Schütze.
    def chi_squared(feature_name, classification)
      chi_squared_algo(
        docs_with_feature_and_class(feature_name, classification),
        docs_with_class_and_not_feature(classification, feature_name),
        docs_with_feature_and_not_class(feature_name, classification),
        docs_without_feature_or_class(feature_name, classification)
      )
    end
  
    def chi_squared_algo(o11, o10, o01, o00)
      denominator = ((o11 + o01) * (o11 + o10) * (o10 + o00) * (o01 + o00))
      numerator   = ((o11 + o10 + o01 + o00) * ((o11 * o00 - o10 * o01)**2))
      # Checking zero to avoid producing Infinity
      denominator.zero? ? 0.0 : numerator.to_f / denominator.to_f
    end
    
    # A class to hold the values associated with a feature. These values are
    # important for feature selection.
    class FeatureValues
      attr_accessor :docs_with_feature

      def initialize()
        @classes = Hash.new(0)
        @docs_with_feature = 0
      end

      def add_document_with_class(classification)
        @classes[classification] += 1
        @docs_with_feature += 1
      end

      def docs_with_class(classification)
        @classes[classification]
      end
      
    end
    
  end
end