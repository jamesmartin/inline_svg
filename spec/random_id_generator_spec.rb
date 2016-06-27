require_relative '../lib/inline_svg/random_id_generator'

describe InlineSvg::RandomIdGenerator do
  it "generates a pseudo-random ID based on a salt" do
    expect(OpenSSL::Digest::SHA1).to receive(:digest).with("some-base-some-salt").
      and_return("some-id")
    expect(InlineSvg::RandomIdGenerator.generate(base: "some-base", salt: "some-salt")).
      to eq("some-id")
  end
end
