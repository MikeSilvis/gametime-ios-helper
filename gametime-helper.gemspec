# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gametime/helper/version'

Gem::Specification.new do |spec|
  spec.name          = "gametime-helper"
  spec.version       = Gametime::Helper::VERSION
  spec.authors       = ["Mike Silvis"]
  spec.email         = ["mike@gametime.co"]

  spec.summary       = %q{Ruby CLI Gem to verify various key metrics before submitting}
  spec.description   = %q{Checks localization, tracking events, etc}
  spec.homepage      = "http://gametime.co"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['gametime']
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "colorize"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake", "~> 10.0"
end
