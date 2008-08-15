# This file contains extensions to built in Ruby classes.

require 'rubygems'
require 'stemmer'

# Extensions to the array class.
class Array
  # Returns a new array that contains everything except the first element of this one. (just like in lisp)
  def rest
    self.slice(1, size)
  end
  
  # Returns the second item in the array
  def second
    self[1]
  end
  
  # Returns a random item from the array
  def pick_random
    self[rand(self.size)]
  end
  
  # Returns a randomized array
  def randomize
    self.sort_by { rand }
  end
  
  def sum
    inject(0) { |sum, val| sum + val }
  end
  
  # Randomizes array in place
  def randomize!
    self.replace(self.randomize)
  end
end

class Float
  def to_s_decimal_places(decimal_places)
    pattern = "[0-9]*\."
    decimal_places.times { pattern << "[0-9]"}
    return self.to_s.match(pattern)[0]
  end
end

class Symbol
  def to_proc
    proc { |obj, *args| obj.send(self, *args) }
  end
end

# Extensions to the string class.
# We're just including the stemmable module into string. This adds the .stem method.
class String
  include Stemmable
end