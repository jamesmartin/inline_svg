module InlineSvg
  class PropshaftAssetFinder
    class Asset
      attr_reader :asset_finder, :filename

      def initialize(filename, asset_finder)
        @asset_finder = asset_finder
        @filename = filename
      end

      delegate :assets, to: :asset_finder

      def pathname
        asset_path = assets.load_path.find(@filename)
        asset_path&.path
      end
    end

    attr_reader :assets

    def initialize(assets = ::Rails.application.assets)
      @assets = assets
    end

    class << self
      delegate :find_asset, to: :new
    end

    def find_asset(filename)
      Asset.new(filename, self)
    end

    def match?
      defined?(::Propshaft) && assets.instance_of?(Propshaft::Assembly)
    end
  end
end
