# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inline-svg/version'

Gem::Specification.new do |spec|
  spec.name          = "inline-svg"
  spec.version       = InlineSvg::VERSION
  spec.authors       = ["James Martin"]
  spec.email         = ["inline-svg@jmrtn.com"]
  spec.summary       = %q{Embeds an SVG document, inline.}
  spec.description   = %q{Get an SVG into your view and then style it with CSS.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "nokogiri", "~> 1.6"
end
