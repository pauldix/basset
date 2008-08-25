module Basset
  class DataVector
    attr_reader :features
    
    def initialize(array_of_features)
      @features = array_of_features
    end
    
    # The array of features is really a vector of values (integer or rationals)
    # This will convert the array of features into unit length (length of 1)
    # May make a difference in some classificaiton tasks. You'd have to run cross validation
    # on training sets with and without to see if it matters for yours.
    def convert_to_unit
      original_legnth = length
      features.each {|feature| feature.value = feature.value / original_legnth}
    end
    
    def length
      Math.sqrt(@features.inject(0.0) {|sum, feature| sum += feature.value**2})
    end
  end
end