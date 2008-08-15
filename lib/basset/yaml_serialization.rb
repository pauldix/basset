require "yaml"

module YamlSerialization
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods  
    def load_from_file(file_name)
      YAML.load_file(file_name)
    end
  end
  
  def save_to_file(file_name)
    File.open(file_name, 'w') do |file|
      YAML.dump(self, file)
    end
  end
  
end