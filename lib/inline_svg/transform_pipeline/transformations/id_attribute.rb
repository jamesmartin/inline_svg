module InlineSvg::TransformPipeline::Transformations
  class IdAttribute < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["id"] = value
      end
    end
  end
end
