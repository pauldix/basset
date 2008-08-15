Dir[File.join(File.dirname(__FILE__), "basset", "*.rb")].each do |file|
  require file
end

module Basset
  VERSION = "1.0.1"
end