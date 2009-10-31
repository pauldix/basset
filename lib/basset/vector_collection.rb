class Basset::VectorCollection
  def initialize(options)
    @global_frequencies = array_size(options[:feature_count])
    @global_weights     = array_size(options[:feature_count])
    @vector_count       = 0
  end
  
  def entropy_normalize_vectors(input_file, output_file)
    compute_weights(input_file)
    
    output_file.puts "#{@global_weights.size},#{@vector_count}"
    
    input_file.each do |line|
      output_vector = []
      execute_calculation_on_line(line) do |column, count|
        output_vector << "#{column},#{@global_weights[column] * (count + 1)}"
      end
      output_file.puts(output_vector.join(";"))
    end
  end
  
  # the weights computed are used for entropy normalization as documented here:
  # http://www.dcs.shef.ac.uk/~genevieve/lsa_tutorial.htm
  def compute_weights(input_file)
    compute_frequencies(input_file)
    
    vector_count_log = Math.log(@vector_count)
    
    input_file.each do |line|
      execute_calculation_on_line(line) do |column, count|
        p = count.to_f/@global_frequencies[column]
        @global_weights[column] ||= 0
        @global_weights[column] += (p * Math.log(p))/vector_count_log
      end
    end
    input_file.rewind
    
    @global_weights = @global_weights.map {|w| w += 1}
  end
  
  def compute_frequencies(input_file)
    @vector_count = 0
    input_file.each do |line|
      @vector_count += 0
      execute_calculation_on_line(line) do |column, count|
        @global_frequencies[column] ||= 0
        @global_frequencies[column] += count
      end
    end
    
    input_file.rewind
  end
  
  def execute_calculation_on_line(line)
    vector = line_to_vector(line)
    vector.each do |column_and_count|
      yield(column_and_count[0], column_and_count[1])
    end    
  end
  
  def line_to_vector(line)
    line.split(";").map {|v| v.split(",")}
  end

  def array_size(count)
    return count.nil? ? [] : Array.new(count)
  end  
end