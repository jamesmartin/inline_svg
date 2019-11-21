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
      file_path = resolve_path_to(@filename)
      return unless public_path && file_path

      File.join(public_path, file_path)
    end

    private

    def resolve_path_to(name)
      path = name.starts_with?("media/") ? name : "media/#{name}"
      Webpacker.instance.manifest.lookup(path)
    rescue
      Webpacker.instance.manifest.lookup(name)
    end
  end
end
