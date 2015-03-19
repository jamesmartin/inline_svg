module InlineSvg
  class AssetFile
    def self.named(filename)
      asset_path = FindsAssets.by_filename(filename)
      File.read(asset_path)
    end
  end
end
