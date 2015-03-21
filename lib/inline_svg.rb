require "inline_svg/version"
require "inline_svg/action_view/helpers"
require "inline_svg/asset_file"
require "inline_svg/finds_asset_paths"
require "inline_svg/transform_pipeline"

require "inline_svg/railtie" if defined?(Rails)
require 'active_support/core_ext'
require 'nokogiri'

module InlineSvg
  class Configuration
    class Invalid < ArgumentError; end

    attr_reader :asset_finder

    def asset_finder=(finder)
      if finder.respond_to?(:find_asset)
        @asset_finder = finder
      else
        raise InlineSvg::Configuration::Invalid.new("Asset Finder should implement the #find_asset method")
      end
      asset_finder
    end
  end

  @configuration = InlineSvg::Configuration.new

  class << self
    attr_reader :configuration

    def configure
      if block_given?
        yield configuration
      else
        raise InlineSvg::Configuration::Invalid.new('Please set configuration options with a block')
      end
    end
  end
end
