module InlineSvg
  class IdGenerator
    def self.generate(base, salt)
      bytes = Digest::SHA1.digest("#{base}-#{salt}")
      Digest.hexencode(bytes).to_i(16).to_s(36)
    end
  end
end
