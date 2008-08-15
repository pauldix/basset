module Basset
  # Class for running evaluation tests on a classifier, and document 
  # representation.
  # Takes the training_documents, which should be an array of objects that can return a vector of features (like Basset::Document)
  # The args hash has two optional keys {:output => true, :folding_amount => 10} where folding_amount is the amount of cross validation.
  class ClassificationEvaluator
    def initialize(training_documents, args = {})
      args[:output] = true unless args.has_key?(:output)
      @output_to_console = args[:output]
      @folding_amount = (args[:folding_amount] or 10)
      @total_documents_trained = 0
      @document_sets = split_documents_into_cross_validation_sets(training_documents, @folding_amount)
    end
    
    # Classifiers should be an array of basset classifier objects to run cross validation tests on
    def test_with_basset_classifiers(classifiers)
    end

    # Classifiers should be an array of basset classifier objects to run cross validation tests on.
    # chi_value will be passed on to the feature_selector. The default value of 0 will select all features.
    # The block will get called and passed in each training_set and test_set from the document_sets. It should 
    # run some external classifier and return the number of documents from the test_set that were correctly classified.
    def compare_against_basset_classifiers(classifiers, chi_value = 0, &block)
      # initialize the results hash
      results = {"External" => {:correct => 0, :total => 0, :time => 0.0}}
      classifiers.each {|classifier| results[classifier.class] = {:correct => 0, :total => 0, :time => 0.0}}

      # run on each doc set
      @document_sets.each_with_index do |document_set, iteration|
        puts "iteration #{iteration + 1} of #{@document_sets.size}" if @output_to_console
        feature_extractor = nil
        feature_extractor_time = time_execution { feature_extractor = create_feature_extractor(document_set[:training_set], chi_value) }
        number_of_test_documents = document_set[:test_set].size
        
        # do a test run on each classifier
        classifiers.each do |classifier|          
          correct = 0
          time = time_execution { correct = test_run(document_set[:training_set], document_set[:test_set], feature_extractor, classifier) } + feature_extractor_time
          results[classifier.class][:time] += time
          results[classifier.class][:correct] += correct
          results[classifier.class][:total] += number_of_test_documents
          output_results(correct, number_of_test_documents, time, classifier.class) if @output_to_console
        end
          
        # now run the external and gather results
        correct = 0
        time = time_execution { correct = block.call(document_set[:training_set], document_set[:test_set]) }
        results["External"][:time]    += time
        results["External"][:correct] += correct
        results["External"][:total]   += number_of_test_documents
        output_results(correct, number_of_test_documents, time, "External") if @output_to_console
      end
      
      puts "\nFinal Results\n---------------------------------------------------------------------------------------" if @output_to_console
      puts "Trained on #{@total_documents_trained} documents on #{@folding_amount} cross validation runs." if @output_to_console
      if @output_to_console
        results.each_pair {|classifier, results_numbers| output_results(results_numbers[:correct], results_numbers[:total], results_numbers[:time], classifier)}
      end
      
      return results
    end
    
    # It will then feature select and train on 9 and test on 
    # the other. Iterate 10 times using each block as the test set and the others as the 
    # training and combine the results.
    def test_with_cross_validation(training_document_names, folding_amount = 10)
      # make sure it's not in some order
      training_document_names.each {|class_documents| class_documents.randomize!}
    
      # the folding amount determines how big the test set size is. for 10 fold it's 10% and we run 10 times
      total_correct, total_documents = 0, 0
    
      # there's some tricky code here to make sure that the training and test sets have an equal percentage 
      # of docs from each class for each iteration.
      folding_amount.times do |iteration|
        puts "iteration #{iteration + 1} of #{folding_amount}" if @output_to_console
        test_set = []
        training_document_names.each do |class_document_names|
          test_set_size = (class_document_names.size / folding_amount).to_i
          test_set << class_document_names.slice(iteration * test_set_size, test_set_size)
        end
        training_set = []
        training_document_names.each_with_index {|class_document_names, i| training_set += (class_document_names - test_set[i])}
        test_set = test_set.flatten
      
        correct, total = test_run(training_set, test_set)
        total_correct += correct
        total_documents += total
      end

      output_results(total_correct, total_documents) if @output_to_console
      return [total_correct, total_documents]
    end

  private
    # Splits entire set. The goal here is to test classification accuracy
    # using cross validation. 10 fold is the default. So it will split the training set
    # into 10 equal size chunks.
    # training_documents is actually an array of arrays. each class to be considered
    # has an array of documents.
    def split_documents_into_cross_validation_sets(training_documents, folding_amount = 10)
      document_sets = []
      # make sure it's not in some order
      training_documents.each {|class_documents| class_documents.randomize!}
  
      # the folding amount determines how big the test set size is. for 10 fold it's 10% and we run 10 times
      # there's some tricky code here to make sure that the training and test sets have an equal percentage 
      # of docs from each class for each iteration.
      folding_amount.times do |iteration|
        test_set = []
        training_documents.each do |class_documents|
          test_set_size = (class_documents.size / folding_amount).to_i
          test_set << class_documents.slice(iteration * test_set_size, test_set_size)
        end
        training_set = []
        training_documents.each_with_index {|class_documents, i| training_set += (class_documents - test_set[i])}
        test_set = test_set.flatten
        @total_documents_trained += training_set.size
        document_sets << {:training_set => training_set, :test_set => test_set}
      end
      return document_sets
    end

    # this method returns a feature extractor for the passed in training_set using the chi_value
    def create_feature_extractor(training_set, chi_value)
      feature_selector = FeatureSelector.new
      # select features based on training set
      training_set.each do |document| 
        feature_selector.add_document(document)
      end
      if chi_value == 0
        selected_features = feature_selector.all_feature_names
      else
        selected_features = feature_selector.select_features(chi_value)
      end
      puts "selected #{selected_features.size} of #{feature_selector.number_of_features} features for this iteration" if @output_to_console
      return FeatureExtractor.new(selected_features)      
    end
    
    # this is a single run on a training and test set. It will run feature_selection, the feature_extraction, then training, then testing
    def test_run(training_set, testing_set, feature_extractor, classifier)
      puts "training #{classifier.class} on #{training_set.size} documents..." if @output_to_console
      # now train the classifier
      training_set.each do |document| 
        classifier.add_document(document.classification, feature_extractor.extract_numbered(document) )
      end

      puts "running #{classifier.class} on #{testing_set.size} documents..." if @output_to_console
      # now classify test set
      number_correctly_classified = 0
      testing_set.each do |document|
        score, predicted_classification = classifier.classify(feature_extractor.extract_numbered(document))
        number_correctly_classified += 1 if document.classification == predicted_classification
      end

      return number_correctly_classified
    end
  
    def output_results(correct, total, time, classifier_name)
      puts "#{classifier_name} classified #{correct} of #{total} correctly for #{(correct/total.to_f * 100).to_s_decimal_places(2)}% accurcy. Executed run in #{time.to_s_decimal_places(1)} seconds."
    end
  
    def time_execution(&block)
      start_time = Time.now
      yield
      end_time = Time.now
      return end_time - start_time 
    end
  end
end