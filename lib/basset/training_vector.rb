module Basset
  class TrainingVector < DataVector
    attr_reader :classification
    
    def initialize(classification_symbol, array_of_features)
      super(array_of_features)
      @classification = classification_symbol
    end
  end
end