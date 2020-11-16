module TableOfTruth
  class DSL
    # @return [Hash<(String or Symbol)->Array>]
    attr_reader :inputs
    # @return [Array<String or Symbol>]
    attr_reader :input_names
    # @return [Hash<(String or Symbol)->Proc>]
    attr_reader :expressions
    # @return [Array<String or Symbol>]
    attr_reader :expression_names

    def initialize
      @inputs = {}
      @input_names = []
      @expressions = {}
      @expression_names = []
    end

    # @param name [String or Symbol]
    # @param block [Proc]
    # @return [void]
    def expression(name, &block)
      @expressions[name] = block
      @expression_names << name
    end

    # @param name [String or Symbol]
    # @return [void]
    def input(name, values = [false, true])
      @inputs[name] = values
      @input_names << name
    end
  end
end
