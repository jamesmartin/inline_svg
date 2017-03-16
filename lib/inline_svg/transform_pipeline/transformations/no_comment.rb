module InlineSvg::TransformPipeline
  module Transformations
    class NoComment < Transformation
      def transform(doc)
        doc = Nokogiri::XML::Document.parse(doc.to_html)
        doc.xpath("//comment()").each do |comment|
          comment.remove
        end
        doc
      end
    end
  end
end
