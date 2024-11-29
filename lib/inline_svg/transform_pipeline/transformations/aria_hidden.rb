module InlineSvg::TransformPipeline::Transformations
  class AriaHidden < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["aria-hidden"] = value
      end
    end
  end
end
