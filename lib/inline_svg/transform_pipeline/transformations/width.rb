# frozen_string_literal: true

module InlineSvg::TransformPipeline::Transformations
  class Width < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["width"] = value
      end
    end
  end
end
