module InlineSvg
  class ViteAssetFinder
    def self.find_asset(filename)
      new(filename)
    end

    def initialize(filename)
      @filename = filename
      @asset_path = ViteRuby.instance.manifest.path_for(@filename)
    end

    def pathname
      return if @asset_path.blank?

      if ViteRuby.instance.dev_server_running?
        dev_server_asset(@asset_path)
      else
        Rails.root.join("public/#{@asset_path}")
      end
    end

    private

    def dev_server_asset(file_path)
      asset = fetch_from_dev_server(file_path)

      begin
        Tempfile.new(file_path).tap do |file|
          file.binmode
          file.write(asset)
          file.rewind
        end
      rescue StandardError => e
        Rails.logger.error "[inline_svg] Error creating tempfile for #{@filename}: #{e}"
        raise
      end
    end

    def fetch_from_dev_server(file_path)
      http = Net::HTTP.new(ViteRuby.config.host, ViteRuby.config.port)
      http.use_ssl = false
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http.request(Net::HTTP::Get.new(file_path)).body
    rescue StandardError => e
      Rails.logger.error "[inline_svg] Error fetching #{@filename} from webpack-dev-server: #{e}"
      raise
    end
  end
end
