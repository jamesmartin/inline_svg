module InlineSvg::TransformPipeline::Transformations
  class Description < Transformation
    def transform(doc)
      doc = Nokogiri::XML::Document.parse(doc.to_html)
      node = Nokogiri::XML::Node.new('desc', doc)
      node.content = value
      doc.search('svg desc').each { |node| node.remove }
      doc.at_css('svg').prepend_child(node)
      doc
    end
  end
end
