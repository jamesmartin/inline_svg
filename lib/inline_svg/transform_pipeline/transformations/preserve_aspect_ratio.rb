# frozen_string_literal: true

module InlineSvg::TransformPipeline::Transformations
  class PreserveAspectRatio < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["preserveAspectRatio"] = value
      end
    end
  end
end
