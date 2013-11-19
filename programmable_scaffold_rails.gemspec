# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'programmable_scaffold_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "programmable_scaffold_rails"
  spec.version       = ProgrammableScaffoldRails::VERSION
  spec.authors       = ["Fire-Dragon-DoL"]
  spec.email         = ["francesco.belladonna@gmail.com"]
  spec.description   = %q{This gem should support you when using rails scaffold (or a lot of simple CRUD models/views/controllers) in a programmable fashion, removing repeated code when possible and making it configurable}
  spec.summary       = %q{This gem should remove repeated code when using Rails scaffold}
  spec.homepage      = "https://github.com/Fire-Dragon-DoL/programmable_scaffold_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails",         "~> 4.0.0"
  spec.add_dependency "activesupport", "~> 4.0.0"

  spec.add_development_dependency "bundler",      "~> 1.3"
  spec.add_development_dependency "rspec",        "~> 2.14.0"
  spec.add_development_dependency "combustion",   "~> 0.5.1"
  spec.add_development_dependency "sqlite3",      "~> 1.3.8"
  spec.add_development_dependency "faker",        "~> 1.2.0"
  spec.add_development_dependency "factory_girl", "~> 4.3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
end
