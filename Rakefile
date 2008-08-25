# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'spec/rake/spectask'
require './lib/basset.rb'

Hoe.new('basset', Basset::VERSION) do |p|
  p.summary = 'A library for running machine learning algorithms for classification, feature selection and evaluation'
  p.url = 'http://basset.rubyforge.org/'
  
  p.author = ['Paul Dix', 'Bryan Helmkamp']
  p.email = 'paul@pauldix.net'

  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = '' # Release to root
  p.extra_deps << ['stemmer', '>= 1.0.1']  
  p.extra_deps << ['json', '>= 1.1.3']
end

desc "Run all of the specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "\"spec/spec.opts\""]
end

desc "Run all spec with RCov" 
Spec::Rake::SpecTask.new(:coverage) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end
