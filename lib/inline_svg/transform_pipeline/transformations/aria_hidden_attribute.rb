module InlineSvg::TransformPipeline::Transformations
  class AriaHiddenAttribute < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["aria-hidden"] = value
      end
    end
  end
end
