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
        http = Net::HTTP.new(Webpacker.dev_server.host, Webpacker.dev_server.port)
        http.use_ssl = Webpacker.dev_server.https?
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        asset = http.request(Net::HTTP::Get.new(file_path)).body

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
