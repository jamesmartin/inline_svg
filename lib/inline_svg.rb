require "inline_svg/version"
require "inline_svg/action_view/helpers"
require "inline_svg/asset_file"
require "inline_svg/finds_asset_paths"
require "inline_svg/static_asset_finder"
require "inline_svg/transform_pipeline"
require "inline_svg/io_resource"

require "inline_svg/railtie" if defined?(Rails)
require 'active_support/core_ext/string'
require 'nokogiri'

module InlineSvg
  class Configuration
    class Invalid < ArgumentError; end

    attr_reader :asset_finder, :custom_transformations

    def initialize
      @custom_transformations = {}
    end

    def asset_finder=(finder)
      if finder.respond_to?(:find_asset)
        @asset_finder = finder
      else
        # fallback to a naive static asset finder (sprokects >= 3.0 &&
        # config.assets.precompile = false
        # See: https://github.com/jamesmartin/inline_svg/issues/25
        @asset_finder = InlineSvg::StaticAssetFinder
      end
      asset_finder
    end

    def add_custom_transformation(options)
      if incompatible_transformation?(options.fetch(:transform))
        raise InlineSvg::Configuration::Invalid.new("#{options.fetch(:transform)} should implement the .create_with_value and #transform methods")
      end
      @custom_transformations.merge!(Hash[ *[options.fetch(:attribute, :no_attribute), options] ])
    end

    private

    def incompatible_transformation?(klass)
      !klass.is_a?(Class) || !klass.respond_to?(:create_with_value) || !klass.instance_methods.include?(:transform)
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

    def reset_configuration!
      @configuration = InlineSvg::Configuration.new
    end
  end
end
