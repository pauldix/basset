# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name = %q{basset}
  s.version = "1.1.0"
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Dix"]
  s.date = %q{2009-09-27}
  s.email = %q{paul@pauldix.net}
  s.files = [
    "lib/basset.rb",
    "README.textile",
    "spec/spec.opts", 
    "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pauldix/basset}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A wonderful hound that finds patterns in your data using machine learning.}
 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
 
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end