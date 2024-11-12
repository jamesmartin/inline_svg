# frozen_string_literal: true

module InlineSvg::TransformPipeline::Transformations
  class IdAttribute < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["id"] = self.value
      end
    end
  end
end
