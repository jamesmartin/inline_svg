# frozen_string_literal: true

require 'action_view/helpers' if defined?(Rails)
require 'action_view/context' if defined?(Rails)
require 'base64'

module InlineSvg
  module ActionView
    module Helpers
      def inline_svg_tag(filename, transform_params = {})
        with_asset_finder(InlineSvg.configuration.asset_finder) do
          render_inline_svg(filename, transform_params)
        end
      end

      def inline_svg_pack_tag(filename, transform_params = {})
        with_asset_finder(InlineSvg::WebpackAssetFinder) do
          render_inline_svg(filename, transform_params)
        end
      end

      def inline_svg(filename, transform_params = {})
        render_inline_svg(filename, transform_params)
      end

      def inline_svg_data_url(filename, transform_params = {})
        svg = render_inline_svg(filename, transform_params)
        svg = svg.sub(/<\?xml.*?\?>/, "").strip
        svg = svg.gsub(/\s+/, " ")
        base64 = Base64.strict_encode64(svg)
        "data:image/svg+xml;base64,#{base64}"
      end

      private

      def render_inline_svg(filename, transform_params = {})
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

      def read_svg(filename)
        if InlineSvg::IOResource === filename
          InlineSvg::IOResource.read filename
        else
          configured_asset_file.named filename
        end
      end

      def placeholder(filename)
        css_class = InlineSvg.configuration.svg_not_found_css_class
        not_found_message = "'#{ERB::Util.html_escape_once(filename)}' #{extension_hint(filename)}"

        if css_class.nil?
          "<svg><!-- SVG file not found: #{not_found_message}--></svg>".html_safe
        else
          "<svg class='#{css_class}'><!-- SVG file not found: #{not_found_message}--></svg>".html_safe
        end
      end

      def configured_asset_file
        InlineSvg.configuration.asset_file
      end

      def with_asset_finder(asset_finder)
        Thread.current[:inline_svg_asset_finder] = asset_finder
        yield
      ensure
        Thread.current[:inline_svg_asset_finder] = nil
      end

      def extension_hint(filename)
        filename.end_with?(".svg") ? "" : "(Try adding .svg to your filename) "
      end
    end
  end
end
