module InlineSvg
  class WebpackAssetFinder
    def self.find_asset(filename)
      new(filename)
    end

    def initialize(filename)
      @filename = filename
    end

    def pathname
      file_path = Webpacker.instance.manifest.lookup(@filename)
      return unless file_path

      if Webpacker.dev_server.running?
        asset = Net::HTTP.get(Webpacker.dev_server.host, file_path, Webpacker.dev_server.port)

        begin
          Tempfile.new(file_path).tap do |file|
            file.binmode
            file.write(asset)
            file.rewind
          end
        rescue StandardError => e
          Rails.logger.error "Error creating tempfile: #{e}"
          raise
        end

      else
        public_path = Webpacker.config.public_path
        return unless public_path

        File.join(public_path, file_path)
      end
    end
  end
end
