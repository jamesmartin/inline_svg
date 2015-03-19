require 'action_view/helpers' if defined?(Rails)
require 'action_view/context' if defined?(Rails)
require 'nokogiri'
require 'loofah'

module InlineSvg
  module ActionView
    module Helpers
      def inline_svg(filename, options={})
        file = AssetFile.named(filename)
        doc = Loofah::HTML::DocumentFragment.parse file

        if options[:nocomment].present?
          doc.scrub!(:strip)
        end

        svg = doc.at_css 'svg'
        if options[:class]
          svg['class'] = options[:class]
        end

        %i(title desc).each do |child|
          if options[child].present?
            node = Nokogiri::XML::Node.new(child.to_s, doc)
            node.content = options[child]
            svg.add_child node
          end
        end

        doc.to_html.html_safe
      end
    end
  end
end
