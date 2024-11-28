module InlineSvg::TransformPipeline::Transformations
  class FillPath < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        path = svg.at_css("path")
        path["fill"] = value
      end
    end
  end
end
