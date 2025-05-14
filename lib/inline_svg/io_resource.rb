# frozen_string_literal: true

module InlineSvg
  module IOResource
    def self.===(object)
      object.is_a?(IO) || object.is_a?(StringIO) || object.is_a?(Tempfile)
    end

    def self.read(object)
      start = object.pos
      str = object.read
      object.seek start
      str
    end
  end
end
