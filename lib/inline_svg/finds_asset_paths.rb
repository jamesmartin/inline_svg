module InlineSvg
  class FindsAssetPaths
    def self.by_filename(filename)
      configured_asset_finder.find_asset(filename)
    end

    def self.configured_asset_finder
      InlineSvg.configuration.asset_finder
    end
  end
end
