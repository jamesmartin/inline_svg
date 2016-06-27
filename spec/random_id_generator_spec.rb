require_relative '../lib/inline_svg/random_id_generator'

describe InlineSvg::RandomIdGenerator do
  it "generates a hexencoded ID based on a salt" do
    expect(InlineSvg::RandomIdGenerator.generate(base: "some-base", salt: "some-salt")).
      to eq("ksiuuy1jduycacqpoj5smn2kyt9iv02")
  end
end
