# frozen_string_literal: true

module InlineSvg::TransformPipeline::Transformations
  class Height < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["height"] = value
      end
    end
  end
end
