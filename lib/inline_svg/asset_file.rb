module InlineSvg
  class AssetFile
    class FileNotFound < IOError; end

    def self.named(filename)
      asset_path = FindsAssets.by_filename(filename)
      File.read(asset_path)
    rescue Errno::ENOENT
      raise FileNotFound.new("Asset not found: #{asset_path}")
    end
  end
end
