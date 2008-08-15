Author::    Paul Dix  (mailto:paul@pauldix.net)

=Summary
This is a library for running machine learning tasks. 
These include a generic document representation class, a feature selector, a feature extractor, a naive bayes classifier, and a classification evaluator for running tests. The goal was to create a general framework that would be easy to modify for specific problems. I also tried to design the system to be extensible so I could add more classification and clustering algorithms as I get deeper into my studies on machine learning.

=What You Could Use This For
Just in case you don't have a clue what machine learning or classification is, here's a quick example scenario and an explanation of the process. The most popular task is spam identification. To do this you'll first need a set of training documents. This would consist of a number of documents which you have labeled as either spam or not. With training sets, bigger is better. You should probably have at least 100 of each type (spam and not spam). Really 1,000 of each type would be better and 10,000 of each would be super sweet. Once you have the training set the process with this library flows like this:

* Create each as a Document (a class in this library)
* Pass those documents into the FeatureSelector
* Get the best features and pass those into the FeatureExtractor
* Now extract features from each document using the extractor and
* Pass those extracted features to NaiveBayes as part of the training set
* Now you can save the FeatureExtractor and NaiveBayes to a file

That represents the process of selecting features and training the classifier. Once you've done that you can predict if a new previously unseen document is spam or not by just doing the following:

* Load the feature extractor and naive bayes from their files
* Create a new document object from your new unseen document
* Extract the features from that document using the feature extractor and
* Pass those to the classify method of the naive bayes classifier

Something that you'll probably want to do before doing real classification is to test things. Use the ClassificationEvaluator for this. Using the evaluator you can pass your training documents in and have it run through a series of tests to give you an estimate of how successful the classifier will be at predicting unseen documents. Easy classification tasks will generally be > 90% accurate while others can be much harder. Each classification task is different and most of the time you won't know until you actually test it out.

=Contact
I love machine learning and classification so if you have a problem that is giving you trouble don't hesitate to get a hold of me. The same applies for anyone who wants to write additional classifiers, better document representations, or just to tell my my code is amateur.

Author::    Paul Dix  (mailto:paul@pauldix.net)
Site::      http://www.pauldix.net
Freenode::  pauldix in #nyc.rb