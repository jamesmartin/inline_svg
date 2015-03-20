require_relative '../lib/inline_svg'

describe InlineSvg do
  describe "configuration" do
    context "when a block is not given" do
      it "complains" do
        expect do
          InlineSvg.configure
        end.to raise_error(InlineSvg::Configuration::Invalid)
      end
    end

    context "asset finder" do
      it "allows an asset finder to be assigned" do
        sprockets = double('SomethingLikeSprockets', find_asset: 'some asset')
        InlineSvg.configure do |config|
          config.asset_finder = sprockets
        end

        expect(InlineSvg.configuration.asset_finder).to eq sprockets
      end

      it "complains when the provided asset finder does not implement #find_asset" do
        expect do
          InlineSvg.configure do |config|
            config.asset_finder = 'Not a real asset finder'
          end
        end.to raise_error(InlineSvg::Configuration::Invalid, /asset finder.*find_asset/i)
      end
    end
  end
end
