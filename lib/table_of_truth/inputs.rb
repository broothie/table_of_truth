module TableOfTruth
  class Inputs
    # @param inputs [Hash<(String or Symbol)->Boolean>]
    def initialize(inputs)
      @inputs = inputs
      @inputs.each { |key, value| define_singleton_method(key) { value } }
    end
  end
end
