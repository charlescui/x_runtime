class Array
  def to_hash
    _hashify.call(self)
  end
  
  def _hashify
    lambda { |array|
      hash = Hash.new
      array.each_slice(2) do |field, value|
        hash[field] = value
      end
      hash
    }
  end
end