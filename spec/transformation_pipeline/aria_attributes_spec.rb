require 'inline_svg/transform_pipeline'

describe InlineSvg::TransformPipeline::Transformations::AriaAttributes do
  it "adds a role attribute to the SVG document" do
    document = Nokogiri::XML::Document.parse('<svg>Some document</svg>')
    transformation = InlineSvg::TransformPipeline::Transformations::AriaAttributes.create_with_value({})

    expect(transformation.transform(document).to_html).to eq(
      "<svg role=\"img\">Some document</svg>\n"
    )
  end

  context "aria-labelledby attribute" do
    it "adds 'title' when a title element is present" do
      document = Nokogiri::XML::Document.parse('<svg><title>Some title</title>Some document</svg>')
      transformation = InlineSvg::TransformPipeline::Transformations::AriaAttributes.create_with_value({})

      expect(transformation.transform(document).to_html).to eq(
        "<svg role=\"img\" aria-labelledby=\"title\"><title>Some title</title>Some document</svg>\n"
      )
    end

    it "adds 'desc' when a description element is present" do
      document = Nokogiri::XML::Document.parse('<svg><desc>Some description</desc>Some document</svg>')
      transformation = InlineSvg::TransformPipeline::Transformations::AriaAttributes.create_with_value({})

      expect(transformation.transform(document).to_html).to eq(
        "<svg role=\"img\" aria-labelledby=\"desc\"><desc>Some description</desc>Some document</svg>\n"
      )
    end

    it "adds both 'desc' and 'title' when title and description elements are present" do
      document = Nokogiri::XML::Document.parse('<svg><title>Some title</title><desc>Some description</desc>Some document</svg>')
      transformation = InlineSvg::TransformPipeline::Transformations::AriaAttributes.create_with_value({})

      expect(transformation.transform(document).to_html).to eq(
        "<svg role=\"img\" aria-labelledby=\"title desc\"><title>Some title</title>\n<desc>Some description</desc>Some document</svg>\n"
      )
    end
  end
end
