module InlineSvg
  class PropshaftAssetFinder
    def self.assets
      Rails.application.assets
    end

    def self.find_asset(filename)
      new(filename)
    end

    def self.match?
      assets.instance_of?(Propshaft::Assembly)
    rescue NameError
    end

    def initialize(filename)
      @filename = filename
    end

    def pathname
      asset_path = self.class.assets.load_path.find(@filename)
      asset_path&.path
    end
  end
end
