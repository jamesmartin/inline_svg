module InlineSvg::TransformPipeline::Transformations
  def self.built_in_transformations
    {
      nocomment: { transform: NoComment },
      class: { transform: ClassAttribute },
      title: { transform: Title },
      desc: { transform: Description },
      size: { transform: Size },
      height: { transform: Height },
      width: { transform: Width },
      id: { transform: IdAttribute },
      data: { transform: DataAttributes },
      preserve_aspect_ratio: { transform: PreserveAspectRatio },
      aria: { transform: AriaAttributes }
    }
  end

  def self.custom_transformations
    InlineSvg.configuration.custom_transformations
  end

  def self.all_transformations
    built_in_transformations.merge(custom_transformations)
  end

  def self.lookup(transform_params)
    without_empty_values(transform_params).map do |key, value|
      options = all_transformations.fetch(key, { transform: NullTransformation })
      options.fetch(:transform, no_transform).create_with_value(value)
    end
  end

  def self.without_empty_values(params)
    all_default_values.merge(params.reject {|key, value| value.nil?})
  end

  def self.all_default_values
    custom_transformations
      .values
      .select {|opt| opt[:default_value] != nil}
      .map {|opt| [opt[:attribute], opt[:default_value]]}
      .inject({}){|hash, array| hash.merge!(array[0] => array[1])}
  end

  def self.no_transform
    InlineSvg::TransformPipeline::Transformations::NullTransformation
  end
end

require 'inline_svg/transform_pipeline/transformations/transformation'
require 'inline_svg/transform_pipeline/transformations/no_comment'
require 'inline_svg/transform_pipeline/transformations/class_attribute'
require 'inline_svg/transform_pipeline/transformations/title'
require 'inline_svg/transform_pipeline/transformations/description'
require 'inline_svg/transform_pipeline/transformations/size'
require 'inline_svg/transform_pipeline/transformations/height'
require 'inline_svg/transform_pipeline/transformations/width'
require 'inline_svg/transform_pipeline/transformations/id_attribute'
require 'inline_svg/transform_pipeline/transformations/data_attributes'
require 'inline_svg/transform_pipeline/transformations/preserve_aspect_ratio'
require 'inline_svg/transform_pipeline/transformations/aria_attributes'
