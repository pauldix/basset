require File.join(File.dirname(__FILE__), "yaml_serialization")

module Basset

  # A class for running Naive Bayes classification.
  # Documents are added to the classifier. Once they are added
  # it can be used to classify new documents.
  class NaiveBayes
    include YamlSerialization

    def initialize
      @number_of_documents = 0
      @number_of_documents_in_class = Hash.new(0)
      @features = []
      reset_cached_probabilities
    end
  
    # takes a classification which can be a string and
    # a vector of numbered features.
    def add_document(classification, feature_vector)
      reset_cached_probabilities
    
      @number_of_documents_in_class[classification] += 1
      @number_of_documents += 1
      
      feature_vector.each do |feature|
        @features[feature.name] ||= FeatureCount.new
        @features[feature.name].add_count_for_class(feature.value, classification)
      end
    end
  
    # returns the most likely class given a vector of features
    def classify(feature_vector)
      class_probabilities = []
      
      @number_of_documents_in_class.keys.each do |classification|
        class_probability = Math.log10(probability_of_class(classification))
        feature_vector.each do |feature|
          class_probability += Math.log10(probability_of_feature_given_class(feature.name, classification)) * feature.value
        end
        class_probabilities << [class_probability, classification]
      end
      
      # this next bit picks a random item first
      # this covers the case that all the class probabilities are equal and we need to randomly select a class
      max = class_probabilities.pick_random
      class_probabilities.each do |cp|
        max = cp if cp.first > max.first
      end
      max
    end
  
  private
  
    # probabilities are cached when the classification is run. This method resets
    # the cached probabities.
    def reset_cached_probabilities
      @occurences_of_every_feature_in_class = Hash.new
    end

    # The number of times every feature occurs for a given class.
    def number_of_occurences_of_every_feature_in_class(classification)
      # return the cached value, if there is one
      return @occurences_of_every_feature_in_class[classification] if @occurences_of_every_feature_in_class[classification]
      
      # we drop the first (since there is no 0 feature) and sum on the rest
      # the reason the rescue 0 is in there is tricky
      # because of the removal of redundant unigrams, it's possible that one of the features is never used/initialized
      @occurences_of_every_feature_in_class[classification] = @features.rest.compact.inject(0) do |sum, feature_count|
        sum + feature_count.count_for_class(classification)
      end
    end

    # returns the probability of a given class
    def probability_of_class(classification)
      @number_of_documents_in_class[classification] / @number_of_documents.to_f
    end

    # returns the probability of a feature given the class
    def probability_of_feature_given_class(feature, classification)
      # the reason the rescue 0 is in there is tricky
      # because of the removal of redundant unigrams, it's possible that one of the features is never used/initialized
      ((@features[feature].count_for_class(classification) rescue 0) + 1)/ number_of_occurences_of_every_feature_in_class(classification).to_f
    end
  
    # A class to store feature counts
    class FeatureCount
      
      def initialize
        @classes = {}
      end

      def add_count_for_class(count, classification)
        @classes[classification] ||= 0
        @classes[classification] += count
      end

      def count_for_class(classification)
        @classes[classification] || 1
      end

      def count
        @classes.values.sum
      end
      
    end

  end
end