module Basset

  # A class to hold a feature which consists of a name and a value. In the basic sense 
  # of document classification the name would be the word and the value would be the 
  # number of times that word appeared in the document.
  class Feature
    attr_accessor :name, :value
  
    def initialize(name, value = 0.0)
      @name   = name
      @value  = value
    end
  
    def <=>(other)
      ret = self.name <=> other.name
      ret = self.value <=> other.value if ret.zero?
      ret
    end
  
    def ==(other)
      ret = self.name == other.name
      ret = self.value == other.value if ret
      ret
    end
  end
end