require_relative "../lib/inline_svg"

describe InlineSvg::SprocketsAssetFinder do
  it "returns assets from Sprockets" do
    sprockets = double("Sprockets", find_asset: "some asset")
    stub_const("Rails", double("Rails"))
    allow(Rails).to receive_message_chain(:application, :assets).and_return(sprockets)

    expect(described_class.find_asset("some-file")).to eq "some asset"
  end
end
