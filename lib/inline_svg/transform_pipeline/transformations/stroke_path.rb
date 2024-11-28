module InlineSvg::TransformPipeline::Transformations
  class StrokePath < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        path = svg.at_css("path")
        path["stroke"] = value
      end
    end
  end
end
