require_relative '../lib/inline_svg/finds_assets'
require_relative '../lib/inline_svg/asset_file'

describe InlineSvg::AssetFile do
  it "reads data from a file, after qualifying a full path" do
    example_svg_path = File.expand_path(__FILE__, 'files/example.svg')
    expect(InlineSvg::FindsAssets).to receive(:by_filename).with('some filename').and_return example_svg_path

    expect(InlineSvg::AssetFile.named('some filename')).to include('This is a test')
  end
end
