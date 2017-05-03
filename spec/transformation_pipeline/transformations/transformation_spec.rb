require 'inline_svg'
require 'inline_svg/transform_pipeline'

describe InlineSvg::TransformPipeline::Transformations::Transformation do
  context "#with_svg" do
    it "returns a Nokogiri::XML::Document representing the parsed document fragment" do
      document = Nokogiri::XML::Document.parse("<svg>Some document</svg>")

      transformation = InlineSvg::TransformPipeline::Transformations::Transformation.new(:irrelevant)
      expect(transformation.with_svg(document).to_html).to eq(
        "<svg>Some document</svg>\n"
      )
    end

    it "yields to the block when the document contains an SVG element" do
      document = Nokogiri::XML::Document.parse("<svg>Some document</svg>")
      svg = document.at_css("svg")

      transformation = InlineSvg::TransformPipeline::Transformations::Transformation.new(:irrelevant)

      expect do |b|
        transformation.with_svg(document, &b)
      end.to yield_with_args(svg)
    end
  end
end
