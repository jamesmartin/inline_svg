module InlineSvg
  module TransformPipeline
    def self.generate_html_from(svg_file, transform_params)
      document = Nokogiri::XML::Document.parse(svg_file)
      Transformations.lookup(transform_params).reduce(document) do |doc, transformer|
        transformer.transform(doc)
      end.to_html.strip
    end
  end
end

require 'nokogiri'

require_relative 'id_generator'
require_relative 'transform_pipeline/transformations'
