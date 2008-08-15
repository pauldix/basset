module Basset

  # A class for representing a document as a vector of features. It takes the text 
  # of the document and the classification. The vector of features representation is 
  # just a basic bag of words approach.
  class Document
    attr_reader :text, :classification
  
    def initialize(text, classification = nil)
      @text           = text
      @classification = classification
    end
  
    def vector_of_features
      @feature_vector ||= vector_of_features_from_terms_hash( terms_hash_from_words_array( stemmed_words ) )
    end
  
  private

    # returns a hash with each word as a key and the value is the number of times
    # the word appears in the passed in words array
    def terms_hash_from_words_array(words)
      terms = Hash.new(0)
      stemmed_words.each do |term|
        terms[term] += 1
      end
      return terms
    end
  
    def vector_of_features_from_terms_hash(terms)
      terms.collect do |term, frequency|
        Feature.new(term, frequency)
      end
    end
  
    def stemmed_words
      words.collect(&:stem)
    end
  
    def words
      clean_text.split(" ")
    end

    # Remove punctuation, numbers and symbols
    def clean_text
      text.tr("'@_", '').gsub(/\W/, ' ').gsub(/[0-9]/, '')
#      text.tr( ',?.!;:"#$%^&*()_=+[]{}\|<>/`~', " " ) .tr( "@'\-", "")
    end

  end
end