require 'action_view/helpers'
require 'action_view/context'

module InlineSvg
  module ActionView
    module Helpers
      def inline_svg(filename, options={})
        file = File.read(Rails.root.join('app', 'assets', 'images', filename))
        doc = Nokogiri::HTML::DocumentFragment.parse file
        svg = doc.at_css 'svg'
        if options[:class].present?
          svg['class'] = options[:class]
        end
        doc.to_html.html_safe
      end
    end
  end
end
