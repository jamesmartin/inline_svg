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
        # Configure an asset finder for Rails. This will be evaluated when the
        # first SVG is rendered, giving time to the asset pipeline to be done
        # loading.
        config.asset_finder = proc { app.assets }
      end
    end
  end
end
