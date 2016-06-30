module InlineSvg::TransformPipeline::Transformations
  class AriaAttributes < Transformation
    def transform(doc)
      doc = Nokogiri::XML::Document.parse(doc.to_html)
      svg = doc.at_css("svg")

      # Add role
      svg["role"] = "img"

      # Build aria-labelledby string
      aria_elements = []
      doc.search("svg title").each do |element|
        aria_elements << element['id'] = element_id_for("title", element)
      end

      doc.search("svg desc").each do |element|
        aria_elements << element['id'] = element_id_for("desc", element)
      end

      if aria_elements.any?
        svg["aria-labelledby"] = aria_elements.join(" ")
      end

      doc
    end

    def element_id_for(base, element)
      if element['id'].nil?
        InlineSvg::IdGenerator.generate(base, value)
      else
        InlineSvg::IdGenerator.generate(element['id'], value)
      end
    end
  end
end
