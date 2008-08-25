module Basset
  # This acts as a general purpose harness to perform classification tasks. With this you could do feature
  # selection, training, and classification without having to handle any of the details of setting these things up.
  # To use you would do something like this:
  # harness = ClassificationHarness.new(:algorithm => "perceptron")
  # harness.train(an_array_of_training_vectors)
  # harness.classify(data_vector) # => will output the predicted class of the data_vector
  # harness.serialize # => will output a json string that can later be read in by ClassificationHarness.deserialize
  class ClassificationHarness
    
    def initialize(options)
    end
  end
end