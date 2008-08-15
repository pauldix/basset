module Basset
  # This class is an example for how to do custom document representations. In this
  # example, I change the way text is cleaned and don't stem the words. It would also
  # be easy to put in additional hard coded features.
  # The important thing to note is that the new document class only needs one function: vector_of_features
  class DocumentOverrideExample < Document
    def vector_of_features
      @vector_of_features ||= vector_of_features_from_terms_hash( terms_hash_from_words_array( text.gsub(/\W/, ' ').split(' ') ) )
    end
  end
end