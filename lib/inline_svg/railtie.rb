require 'rails/railtie'
module InlineSvg
  class Railtie < ::Rails::Railtie
    initializer "inline_svg.action_view" do |app|
      ActiveSupport.on_load :action_view do
        require "inline_svg/action_view/helpers"
        include InlineSvg::ActionView::Helpers
        InlineSvg.configure do |config|
          config.asset_finder = app.instance_variable_get(:@assets) # In most cases this will be the Sprockets::Environment instance of the Rails app.
        end
      end
    end
  end
end
