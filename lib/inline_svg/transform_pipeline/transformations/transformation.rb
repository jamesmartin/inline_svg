module InlineSvg::TransformPipeline::Transformations
  class Transformation
    def self.create_with_value(value)
      self.new(value)
    end

    attr_reader :value

    def initialize(value)
      @value = value
    end

    def transform(*)
      raise "#transform should be implemented by subclasses of Transformation"
    end
  end

  class NullTransformation < Transformation
    def transform(doc)
      doc
    end
  end
end
