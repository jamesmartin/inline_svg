module InlineSvg::TransformPipeline::Transformations
  class ClassAttribute < Transformation
    def transform(doc)
      doc = Nokogiri::XML::Document.parse(doc.to_html)
      svg = doc.at_css "svg"
      classes = (svg["class"] || "").split(" ")
      classes << value
      svg["class"] = classes.join(" ")
      doc
    end
  end
end
