module InlineSvg::TransformPipeline::Transformations
  def self.all_transformations
    {
      nocomment: NoComment,
      class: ClassAttribute,
      title: Title,
      desc: Description,
      size: Size,
      height: Height,
      id: IdAttribute,
      data: DataAttributes
    }
  end

  def self.lookup(transform_params)
    without_empty_values(transform_params).map do |key, value|
      all_transformations.fetch(key, NullTransformation).create_with_value(value)
    end
  end

  def self.without_empty_values(params)
    params.reject {|key, value| value.nil?}
  end
end

require 'inline_svg/transform_pipeline/transformations/transformation'
require 'inline_svg/transform_pipeline/transformations/no_comment'
require 'inline_svg/transform_pipeline/transformations/class_attribute'
require 'inline_svg/transform_pipeline/transformations/title'
require 'inline_svg/transform_pipeline/transformations/description'
require 'inline_svg/transform_pipeline/transformations/size'
require 'inline_svg/transform_pipeline/transformations/height'
require 'inline_svg/transform_pipeline/transformations/id_attribute'
require 'inline_svg/transform_pipeline/transformations/data_attributes'
