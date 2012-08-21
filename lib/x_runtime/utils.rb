module XRuntime
  module Utils
    class << self
      def to_hash(data)
        case data
        when Array
          array_hashify.call(data)
        end
      end
  
      def array_hashify
        lambda { |array|
          hash = Hash.new
          array.each_slice(2) do |field, value|
            hash[field] = value
          end
          hash
        }
      end
    end
  end
end