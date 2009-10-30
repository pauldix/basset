class Basset::FeatureCollection
  class Feature
    attr_accessor :index, :frequency
    
    def initialize(options = {})
      @index = options[:index]
      @frequency = options[:frequency]
    end
  end
  
  def initialize(options = {})
    @feature_map = {}
    @sparse_vector_separator = (options[:sparse_vector_separator] || ",")
  end
  
  def add_row(features)
    features.each do |f|
       feature = (@feature_map[f] ||= Feature.new(:index => @feature_map.size, :frequency => 0))
       feature.frequency += 1
    end
  end
  
  def features
    @feature_map.keys.sort
  end
  
  def index_of(feature)
    f = @feature_map[feature]
    return f.nil? ? nil : f.index
  end
  
  def global_frequency(feature)
    @feature_map[feature].frequency
  end
  
  def features_to_vector(features)
    vector = Array.new(@feature_map.size, 0)
    features.each do |f|
      index = index_of(f) 
      vector[index] += 1 if index
    end
    vector
  end
  
  def features_to_sparse_vector(features)
    sparse_vector = []
    features_to_vector(features).each_with_index do |f, i|
      sparse_vector << "#{i}#{@sparse_vector_separator}#{f}" unless f == 0
    end
    sparse_vector
  end
end