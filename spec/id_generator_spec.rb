require_relative '../lib/inline_svg/id_generator'

describe InlineSvg::IdGenerator do
  it "generates a hexencoded ID based on a salt" do
    expect(InlineSvg::IdGenerator.generate("some-base", "some-salt")).
      to eq("ksiuuy1jduycacqpoj5smn2kyt9iv02")
  end
end
