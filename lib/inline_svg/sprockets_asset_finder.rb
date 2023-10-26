module InlineSvg
  module SprocketsAssetFinder
    def self.assets
      Rails.application.assets
    end

    def self.find_asset(*args, **options)
      assets.find_asset(*args, **options)
    end

    def self.match?
      assets.respond_to?(:find_asset)
    rescue NameError
    end
  end
end
