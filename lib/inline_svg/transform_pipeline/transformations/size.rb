# frozen_string_literal: true

module InlineSvg::TransformPipeline::Transformations
  class Size < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        svg["width"] = width_of(value)
        svg["height"] = height_of(value)
      end
    end

    def width_of(value)
      value.split("*").map(&:strip)[0]
    end

    def height_of(value)
      value.split("*").map(&:strip)[1] || width_of(value)
    end
  end
end
