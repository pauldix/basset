class Basset::FeatureCollection
  attr_accessor :row_count

  def initialize(options = {})
    @feature_map = options[:feature_map] || {}
    @row_count = options[:row_count] || 0
    @ordered_features = []
  end

  def add_row(features)
    @row_count += 1
    features.uniq.each do |f|
      feature = @feature_map[f]
      if feature
        feature[1] += 1
      else
        @ordered_features << f
        @feature_map[f] = [@feature_map.size, 1]
      end
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

  def document_frequency(feature)
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

  # The options hash has one option :value which can be either :tf or :tf_idf.
  # Note that if you choose :tf_idf, you must do it only after you have added all rows.
  # this typically means looping through your data set twice. first to add rows, second to
  # extract sparse feature vectors
  def features_to_sparse_vector(features, options = {})
    sparse_vector = Hash.new {|h, k| h[k] = 0}

    features.each do |feature|
      index = index_of(feature)
      sparse_vector[index] += 1 if index
    end

    if options[:value] == :tf || options[:value] == :tf_idf
      sparse_vector.keys.each {|key| sparse_vector[key] = sparse_vector[key] / features.size.to_f}

      if options[:value] == :tf_idf
        features.uniq.each do |feature|
          index_and_count = @feature_map[feature]
          if index_and_count
            if index_and_count.size == 3
              idf = index_and_count[2]
            else
              idf = Math.log10(@row_count / index_and_count[1])
              index_and_count << idf
            end
            index = index_and_count[0]
            sparse_vector[index] = sparse_vector[index] * idf
          end
        end
      end
    end

    sparse_vector.keys.sort.map {|k| [k, sparse_vector[k]]}
  end

  def purge_features_occuring_less_than(times)
    @feature_map.each_pair do |feature, index_and_count|
      @feature_map.delete(feature) if index_and_count[1] < times
    end

    index = 0
    @ordered_features.each do |f|
      index_and_count = @feature_map[f]
      if index_and_count
        index_and_count[0] = index
        index += 1
      end
    end
  end

  def serializable_hash_map
    {
      :row_count => @row_count,
      :feature_map => @feature_map
    }
  end

  def to_json
    serializable_hash_map.to_json
  end

  def self.from_json_hash(json)
    new({
      :feature_map => json["feature_map"],
      :row_count   => json["row_count"],
    })
  end

  def self.from_json(json_string)
    json = JSON.parse(json_string)
    from_json_hash(json)
  end
end