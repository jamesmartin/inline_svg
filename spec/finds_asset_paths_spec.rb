# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InlineSvg::FindsAssetPaths do
  after do
    InlineSvg.reset_configuration!
  end

  context "when sprockets finder returns an object which supports only the pathname method" do
    it "returns fully qualified file paths from Sprockets" do
      sprockets = double('SprocketsDouble')

      expect(sprockets).to receive(:find_asset).with('some-file')
                                               .and_return(double(pathname: Pathname('/full/path/to/some-file')))

      InlineSvg.configure do |config|
        config.asset_finder = sprockets
      end

      expect(InlineSvg::FindsAssetPaths.by_filename('some-file')).to eq Pathname('/full/path/to/some-file')
    end
  end

  context "when sprockets finder returns an object which supports only the filename method" do
    it "returns fully qualified file paths from Sprockets" do
      sprockets = double('SprocketsDouble')

      expect(sprockets).to receive(:find_asset).with('some-file')
                                               .and_return(double(filename: Pathname('/full/path/to/some-file')))

      InlineSvg.configure do |config|
        config.asset_finder = sprockets
      end

      expect(InlineSvg::FindsAssetPaths.by_filename('some-file')).to eq Pathname('/full/path/to/some-file')
    end
  end

  context "when asset is not found" do
    it "returns nil" do
      sprockets = double('SprocketsDouble')

      expect(sprockets).to receive(:find_asset).with('some-file').and_return(nil)

      InlineSvg.configure do |config|
        config.asset_finder = sprockets
      end

      expect(InlineSvg::FindsAssetPaths.by_filename('some-file')).to be_nil
    end
  end

  context "when propshaft finder returns an object which supports only the pathname method" do
    it "returns fully qualified file paths from Propshaft" do
      propshaft = double('PropshaftDouble')

      expect(propshaft).to receive(:find_asset).with('some-file')
                                               .and_return(double(pathname: Pathname('/full/path/to/some-file')))

      InlineSvg.configure do |config|
        config.asset_finder = propshaft
      end

      expect(InlineSvg::FindsAssetPaths.by_filename('some-file')).to eq Pathname('/full/path/to/some-file')
    end
  end

  context "when webpack finder returns an object with a relative asset path" do
    it "returns the fully qualified file path" do
      shakapacker = double('ShakapackerDouble')

      expect(shakapacker).to receive(:find_asset).with('some-file')
                                                 .and_return(double(filename: Pathname('/full/path/to/some-file')))

      InlineSvg.configure do |config|
        config.asset_finder = shakapacker
      end

      expect(InlineSvg::FindsAssetPaths.by_filename('some-file')).to eq Pathname('/full/path/to/some-file')
    end
  end

  context "when webpack finder returns an object with an absolute http asset path" do
    it "returns the fully qualified file path" do
      shakapacker = double('ShakapackerDouble')

      expect(shakapacker).to receive(:find_asset).with('some-file')
                                                 .and_return(double(filename: Pathname('https://test.example.org/full/path/to/some-file')))

      InlineSvg.configure do |config|
        config.asset_finder = shakapacker
      end

      expect(InlineSvg::FindsAssetPaths.by_filename('some-file')).to eq Pathname('https://test.example.org/full/path/to/some-file')
    end
  end
end
