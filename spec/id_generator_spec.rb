# frozen_string_literal: true

require "inline_svg/id_generator"

RSpec.describe InlineSvg::IdGenerator do
  it "generates a hexencoded ID based on a salt and a random value" do
    randomizer = -> { "some-random-value" }

    expect(InlineSvg::IdGenerator.generate("some-base", "some-salt", randomness: randomizer))
      .to eq("at2c17mkqnvopy36iccxspura7wnreqf")
  end
end
