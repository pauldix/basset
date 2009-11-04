class Basset::FeatureCollection
  attr_accessor :row_count
  
  def initialize(options = {})
    @feature_map = options[:feature_map] || {}
    @sparse_vector_separator = options[:sparse_vector_separator] || ","
    @row_count = options[:row_count] || 0
  end
  
  def add_row(features)
    @row_count += 1
    features.each do |f|
       feature = (@feature_map[f] ||= [@feature_map.size, 0])
       feature[1] += 1
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
    f[0] if f
  end
  
  def global_frequency(feature)
    f = @feature_map[feature]
    f[1] if f
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
  
  def to_json
    {
      :row_count => @row_count,
      :sparse_vector_separator => @sparse_vector_separator,
      :feature_map => @feature_map
    }.to_json
  end
  
  def self.from_json(json_string)
    json = JSON.parse(json_string)
    new({
      :feature_map => json["feature_map"],
      :row_count   => json["row_count"],
      :sparse_vector_separator => json["sparse_vector_separator"]
    })
  end
end