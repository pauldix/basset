class Basset::FeatureCollection
  attr_accessor :row_count
  
  def initialize(options = {})
    @feature_map = {}
    @sparse_vector_separator = (options[:sparse_vector_separator] || ",")
    @row_count = 0
  end
  
  def add_row(features)
    @row_count += 1
    features.each do |f|
       feature = (@feature_map[f] ||= Feature.new(:index => @feature_map.size, :frequency => 0))
       feature.frequency += 1
    end
  end
  
  def feature_count
    @feature_map.size
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
    sparse_vector = Hash.new {|h, k| h[k] = 0}
    features.each do |feature|
      index = index_of(feature)
      sparse_vector[index] += 1 if index
    end
    sparse_vector.keys.sort.map {|k| "#{k},#{sparse_vector[k]}"}
  end
  
  class Feature
    attr_accessor :index, :frequency
    
    def initialize(options = {})
      @index = options[:index]
      @frequency = options[:frequency]
    end
  end  
end