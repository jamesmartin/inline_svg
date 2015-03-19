module InlineSvg
  class AssetFile
    def self.named(filename)
      File.read(Rails.root.join('app', 'assets', 'images', filename))
    end
  end
end
