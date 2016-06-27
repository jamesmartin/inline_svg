module InlineSvg
  class RandomIdGenerator
    def self.generate(base:, salt: nil)
      OpenSSL::Digest::SHA1.digest("#{base}-#{salt}")
    end
  end
end
