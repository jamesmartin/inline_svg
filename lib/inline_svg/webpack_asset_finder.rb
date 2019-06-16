module InlineSvg
  class WebpackAssetFinder
    def self.find_asset(filename)
      new(filename)
    end

    def initialize(filename)
      @filename = filename
    end

    def pathname
      public_path = Webpacker.config.public_path
      file_path = Webpacker.instance.manifest.lookup(@filename)
      return unless public_path && file_path

      File.join(public_path, file_path)
    end
  end
end
