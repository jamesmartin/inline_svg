require 'action_view/helpers' if defined?(Rails)
require 'action_view/context' if defined?(Rails)
require 'nokogiri'

module InlineSvg
  module ActionView
    module Helpers
      def inline_svg(filename, options={})
        file = File.read(Rails.root.join('app', 'assets', 'images', filename))
        doc = Nokogiri::HTML::DocumentFragment.parse file
        svg = doc.at_css 'svg'
        if options[:class]
          svg['class'] = options[:class]
        end
        if options[:title].present?
          title = Nokogiri::XML::Node.new("title", doc)
          title.content = options[:title]
          svg.add_child title
        end
        if options[:desc].present?
          desc = Nokogiri::XML::Node.new("desc", doc)
          desc.content = options[:desc]
          svg.add_child desc
        end
        doc.to_html.html_safe
      end
    end
  end
end
