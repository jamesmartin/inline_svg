require 'action_view/helpers' if defined?(Rails)
require 'action_view/context' if defined?(Rails)

module InlineSvg
  module ActionView
    module Helpers
      def inline_svg(filename, transform_params={})
        begin
          svg_file = if InlineSvg::IOResource === filename
            InlineSvg::IOResource.read filename
          else
            configured_asset_file.named filename
          end
        rescue InlineSvg::AssetFile::FileNotFound
          if InlineSvg.configuration.svg_not_found_css_class.nil?
            return "<svg><!-- SVG file not found: '#{filename}' #{extension_hint(filename)}--></svg>".html_safe
          else
            return "<svg class='#{InlineSvg.configuration.svg_not_found_css_class}'><!-- SVG file not found: '#{filename}' #{extension_hint(filename)}--></svg>".html_safe
          end
        end

        InlineSvg::TransformPipeline.generate_html_from(svg_file, transform_params).html_safe
      end

      private

      def configured_asset_file
        InlineSvg.configuration.asset_file
      end

      def extension_hint(filename)
        filename.ends_with?(".svg") ? "" : "(Try adding .svg to your filename) "
      end
    end
  end
end
