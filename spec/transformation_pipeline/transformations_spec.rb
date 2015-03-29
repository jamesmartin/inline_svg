require 'inline_svg/transform_pipeline'

describe InlineSvg::TransformPipeline::Transformations do
  context "looking up transformations" do
    it "returns configured transformations when parameters are supplied" do
      transformations = InlineSvg::TransformPipeline::Transformations.lookup(
        nocomment: 'irrelevant',
        class: 'irrelevant',
        title: 'irrelevant',
        desc: 'irrelevant',
        size: 'irrelevant',
        height: 'irrelevant',
        id: 'irrelevant',
        data: 'irrelevant'
      )

      expect(transformations.map(&:class)).to match_array([
        InlineSvg::TransformPipeline::Transformations::NoComment,
        InlineSvg::TransformPipeline::Transformations::ClassAttribute,
        InlineSvg::TransformPipeline::Transformations::Title,
        InlineSvg::TransformPipeline::Transformations::Description,
        InlineSvg::TransformPipeline::Transformations::Size,
        InlineSvg::TransformPipeline::Transformations::Height,
        InlineSvg::TransformPipeline::Transformations::IdAttribute,
        InlineSvg::TransformPipeline::Transformations::DataAttributes
      ])
    end

    it "returns a benign transformation when asked for an unknown transform" do
      transformations = InlineSvg::TransformPipeline::Transformations.lookup(
        not_a_real_transform: 'irrelevant'
      )

      expect(transformations.map(&:class)).to match_array([
        InlineSvg::TransformPipeline::Transformations::NullTransformation
      ])
    end

    it "does not return a transformation when a value is not supplied" do
      transformations = InlineSvg::TransformPipeline::Transformations.lookup(
        title: nil
      )

      expect(transformations.map(&:class)).to match_array([])
    end
  end
end
