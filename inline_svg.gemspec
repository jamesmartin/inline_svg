# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inline_svg/version'

Gem::Specification.new do |spec|
  spec.name          = "inline_svg"
  spec.version       = InlineSvg::VERSION
  spec.authors       = ["James Martin"]
  spec.email         = ["inline_svg@jmrtn.com"]
  spec.summary       = 'Embeds an SVG document, inline.'
  spec.description   = 'Get an SVG into your view and then style it with CSS.'
  spec.homepage      = "https://github.com/jamesmartin/inline_svg"
  spec.license       = "MIT"

  spec.files         = Dir.glob('{CHANGELOG.md,LICENSE.txt,README.md,lib/**/*.rb}', File::FNM_DOTMATCH)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "nokogiri", ">= 1.16"
end
