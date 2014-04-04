# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'machine_classifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'machine_classifier'
  spec.version       = MachineClassifier::VERSION
  spec.authors       = ['Joe Yates, Riccardo Lucatuorto']
  spec.email         = ['joe.g.yates@gmail.com, gnuduncan@gmail.com']
  spec.summary       = %q{A client for calling Machine learning classifiers.}
  spec.description   = %q{Call GooglePrediction's classification API}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'google-api-client'
  
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
