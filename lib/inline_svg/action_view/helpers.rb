require 'action_view/helpers' if defined?(Rails)
require 'action_view/context' if defined?(Rails)

module InlineSvg
  module ActionView
    module Helpers
      def inline_svg(filename, transform_params={})
        begin
          svg_file = read_svg(filename)
        rescue InlineSvg::AssetFile::FileNotFound => error
          raise error if InlineSvg.configuration.raise_on_file_not_found?
          return placeholder(filename) unless transform_params[:fallback].present?

          if transform_params[:fallback].present?
            begin
              svg_file = read_svg(transform_params[:fallback])
            rescue InlineSvg::AssetFile::FileNotFound
              placeholder(filename)
            end
          end
        end

        InlineSvg::TransformPipeline.generate_html_from(svg_file, transform_params).html_safe
      end

      private

      def read_svg(filename)
        if InlineSvg::IOResource === filename
          InlineSvg::IOResource.read filename
        else
          configured_asset_file.named filename
        end
      end

      def placeholder(filename)
        css_class = InlineSvg.configuration.svg_not_found_css_class
        not_found_message = "'#{filename}' #{extension_hint(filename)}"

        if css_class.nil?
          return "<svg><!-- SVG file not found: #{not_found_message}--></svg>".html_safe
        else
          return "<svg class='#{css_class}'><!-- SVG file not found: #{not_found_message}--></svg>".html_safe
        end
      end

      def configured_asset_file
        InlineSvg.configuration.asset_file
      end

      def extension_hint(filename)
        filename.ends_with?(".svg") ? "" : "(Try adding .svg to your filename) "
      end
    end
  end
end
