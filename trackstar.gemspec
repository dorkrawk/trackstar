# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trackstar/version'

Gem::Specification.new do |spec|
  spec.name          = "trackstar"
  spec.version       = Trackstar::VERSION
  spec.authors       = ["Dave"]
  spec.email         = ["dave.schwantes@gmail.com"]

  spec.summary       = "A commandline based progress tracker."
  spec.description   = "Create a simple log and track your practice hours from the commandline."
  spec.homepage      = "https://github.com/dorkrawk/trackstar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['trackstar']
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 6.0.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.3"
end
