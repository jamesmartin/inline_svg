require 'rails/railtie'
module InlineSvg
  class Railtie < ::Rails::Railtie
    initializer "inline_svg.action_view" do |app|
      ActiveSupport.on_load :action_view do
        require "inline_svg/action_view/helpers"
        include InlineSvg::ActionView::Helpers
      end
    end

    config.after_initialize do |app|
      InlineSvg.configure do |config|
        # Configure the asset_finder:
        # Only set this when a user-configured asset finder has not been
        # configured already.
        if config.asset_finder.nil?
          if assets = app.instance_variable_get(:@assets)
            # In default Rails apps, this will be a fully operational
            # Sprockets::Environment instance
            config.asset_finder = assets
          elsif defined?(Webpacker)
            # Use Webpacker when it's available
            config.asset_finder = InlineSvg::WebpackAssetFinder
          else
            # Fallback to the StaticAssetFinder if all else fails.
            # This will be used in cases where assets are precompiled and other
            # production settings.
            config.asset_finder = InlineSvg::StaticAssetFinder
          end
        end
      end
    end
  end
end
