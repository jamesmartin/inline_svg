require 'open-uri'

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
        asset = open("#{Webpacker.dev_server.protocol}://#{Webpacker.dev_server.host_with_port}#{file_path}")

        begin
          tempfile = Tempfile.new(@filename)
          tempfile.binmode
          tempfile.write(asset.read)
          tempfile.rewind
          tempfile
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
