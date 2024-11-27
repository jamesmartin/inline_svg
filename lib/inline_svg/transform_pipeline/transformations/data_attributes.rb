module InlineSvg::TransformPipeline::Transformations
  class DataAttributes < Transformation
    def transform(doc)
      with_svg(doc) do |svg|
        with_valid_hash_from(value).each_pair do |name, data|
          svg["data-#{dasherize(name)}"] = data
        end
      end
    end

    private

    def with_valid_hash_from(hash)
      Hash.try_convert(hash) || {}
    end

    def dasherize(string)
      string.to_s.tr('_', "-")
    end
  end
end
