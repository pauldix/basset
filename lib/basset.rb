$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

module Basset; end;

require 'json'
require 'basset/parser'
require 'basset/feature_collection'
require 'basset/vector_collection'

module Basset
  VERSION = "2.0.1"
end