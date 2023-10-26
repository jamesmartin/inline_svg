require_relative '../lib/inline_svg'

class MyCustomTransform
  def self.create_with_value(value); end
  def transform(doc); end
end

class MyInvalidCustomTransformKlass
  def transform(doc); end
end

class MyInvalidCustomTransformInstance
  def self.create_with_value(value); end
end

class MyCustomAssetFile
  def self.named(filename); end
end

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
      context "when Sprockets is detected" do
        it "uses the Sprockets asset finder" do
          sprockets = double("Sprockets", find_asset: "some asset")
          stub_const("Rails", double("Rails"))
          allow(Rails).to receive_message_chain(:application, :assets).and_return(sprockets)

          expect(InlineSvg.configuration.asset_finder).to be_a InlineSvg::SprocketsAssetFinder
        end
      end

      context "when Propshaft is detected" do
        it "uses the Propshaft asset finder" do
          stub_const("Propshaft::Assembly", Class.new)
          stub_const("Rails", double("Rails"))
          allow(Rails).to receive_message_chain(:application, :assets).and_return(Propshaft::Assembly.new)

          expect(InlineSvg.configuration.asset_finder).to be_a InlineSvg::PropshaftAssetFinder
        end
      end

      context "when Sprockets and Propshaft are not detected" do
        it "uses the static asset finder" do
          stub_const("Rails", double("Rails"))
          allow(Rails).to receive_message_chain(:application, :assets).and_return(nil)

          expect(InlineSvg.configuration.asset_finder).to be_a InlineSvg::StaticAssetFinder
        end
      end

      it "allows an asset finder to be assigned" do
        asset_finder = double("An asset finder", find_asset: "some asset")
        InlineSvg.configure do |config|
          config.asset_finder = asset_finder
        end

        expect(InlineSvg.configuration.asset_finder).to eq asset_finder
      end

      it "raises an error if the asset finder does not implement the find_asset method" do
        expect {
          InlineSvg.configure do |config|
            config.asset_finder = "Not a real asset finder"
          end
        }.to raise_error(InlineSvg::Configuration::Invalid, /asset_finder should implement the #find_asset method/)
      end

      after do
        InlineSvg.reset_configuration!
      end
    end

    context "configuring a custom asset file" do
      it "falls back to the built-in asset file implementation by deafult" do
        expect(InlineSvg.configuration.asset_file).to eq(InlineSvg::AssetFile)
      end

      it "adds a collaborator that meets the interface specification" do
        InlineSvg.configure do |config|
          config.asset_file = MyCustomAssetFile
        end

        expect(InlineSvg.configuration.asset_file).to eq MyCustomAssetFile
      end

      it "rejects a collaborator that does not conform to the interface spec" do
        bad_asset_file = double("bad_asset_file")

        expect do
          InlineSvg.configure do |config|
            config.asset_file = bad_asset_file
          end
        end.to raise_error(InlineSvg::Configuration::Invalid, /asset_file should implement the #named method/)
      end

      it "rejects a collaborator that implements the correct interface with the wrong arity" do
        bad_asset_file = double("bad_asset_file", named: nil)

        expect do
          InlineSvg.configure do |config|
            config.asset_file = bad_asset_file
          end
        end.to raise_error(InlineSvg::Configuration::Invalid, /asset_file should implement the #named method with arity 1/)
      end
    end

    context "configuring the default svg-not-found class" do
      it "sets the class name" do
        InlineSvg.configure do |config|
          config.svg_not_found_css_class = 'missing-svg'
        end

        expect(InlineSvg.configuration.svg_not_found_css_class).to eq 'missing-svg'
      end
    end

    context "configuring custom transformation" do
      it "allows a custom transformation to be added" do
        InlineSvg.configure do |config|
          config.add_custom_transformation(attribute: :my_transform, transform: MyCustomTransform)
        end

        expect(InlineSvg.configuration.custom_transformations).to eq({my_transform: {attribute: :my_transform, transform: MyCustomTransform}})
      end

      it "rejects transformations that do not implement .create_with_value" do
        expect do
          InlineSvg.configure do |config|
            config.add_custom_transformation(attribute: :irrelevant, transform: MyInvalidCustomTransformKlass)
          end
        end.to raise_error(InlineSvg::Configuration::Invalid, /#{MyInvalidCustomTransformKlass} should implement the .create_with_value and #transform methods/)
      end

      it "rejects transformations that does not implement #transform" do
        expect do
          InlineSvg.configure do |config|
            config.add_custom_transformation(attribute: :irrelevant, transform: MyInvalidCustomTransformInstance)
          end
        end.to raise_error(InlineSvg::Configuration::Invalid, /#{MyInvalidCustomTransformInstance} should implement the .create_with_value and #transform methods/)
      end

      it "rejects transformations that are not classes" do
        expect do
          InlineSvg.configure do |config|
            config.add_custom_transformation(attribute: :irrelevant, transform: :not_a_class)
          end
        end.to raise_error(InlineSvg::Configuration::Invalid, /#{:not_a_class} should implement the .create_with_value and #transform methods/)
      end
    end
  end
end
