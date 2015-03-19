module InlineSvg
  class FindsAssets
    def self.by_filename(filename)
      Rails.root.join('app', 'assets', 'images', filename) if defined?(Rails)
    end
  end
end
