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
        element['id'] = InlineSvg::RandomIdGenerator.generate(salt: value)
        aria_elements << element['id']
      end

      doc.search("svg desc").each do |element|
        element['id'] = InlineSvg::RandomIdGenerator.generate(salt: value)
        aria_elements << element['id']
      end

      if aria_elements.any?
        svg["aria-labelledby"] = aria_elements.join(" ")
      end

      doc
    end
  end
end
