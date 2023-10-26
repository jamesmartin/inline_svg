module InlineSvg
  class SprocketsAssetFinder
    attr_reader :assets

    def initialize(assets = ::Rails.application.assets)
      @assets = assets
    end

    class << self
      delegate :find_asset, to: :new
    end

    delegate :find_asset, to: :assets

    def match?
      assets.respond_to?(:find_asset)
    end
  end
end
