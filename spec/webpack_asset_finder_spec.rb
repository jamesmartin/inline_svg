# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InlineSvg::WebpackAssetFinder do
  context "when the file is not found" do
    it "returns nil" do
      stub_const('Rails', double('Rails').as_null_object)
      stub_const('Shakapacker', double('Shakapacker').as_null_object)
      expect(Shakapacker.manifest).to receive(:lookup).with('some-file').and_return(nil)

      expect(InlineSvg::WebpackAssetFinder.find_asset('some-file').pathname).to be_nil
    end
  end
end
