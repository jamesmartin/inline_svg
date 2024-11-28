require 'inline_svg/transform_pipeline'

describe InlineSvg::TransformPipeline::Transformations::StrokePath do
  it "adds fill attribute to a SVG PATH document" do
    document = Nokogiri::XML::Document.parse('<svg><path d="M12 16V12M12 8H12.01M22 12C22"/></svg>')
    transformation = InlineSvg::TransformPipeline::Transformations::FillPath.create_with_value("#FFFFFF")

    expect(transformation.transform(document).to_html).to eq(
      "<svg><path d=\"M12 16V12M12 8H12.01M22 12C22\" fill=\"#FFFFFF\"></path></svg>\n"
    )
  end
end
