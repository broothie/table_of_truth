require 'colorize'
require 'stringio'
require_relative 'dsl'
require_relative 'inputs'

module TableOfTruth
  class Table
    # @return [Hash<(String or Symbol)->Array>]
    attr_reader :inputs
    # @return [Array<String or Symbol>]
    attr_reader :input_names
    # @return [Hash<(String or Symbol)->Proc>]
    attr_reader :expressions
    # @return [Array<String or Symbol>]
    attr_reader :expression_names

    def initialize(&block)
      dsl = DSL.new
      dsl.instance_eval(&block)

      @inputs = dsl.inputs
      @input_names = dsl.input_names
      @expressions = dsl.expressions
      @expression_names = dsl.expression_names
    end

    # @return [Array<Hash{String->Boolean}>]
    def results
      @results ||= input_table.map do |inputs|
        result = inputs.dup
        expressions.each { |name, expression| result[name] = Inputs.new(inputs).instance_eval(&expression) }

        result
      end
    end

    # @return [void]
    def print!(colorize: true)
      String.disable_colorization = !colorize

      builder = StringIO.new

      # Header
      input_header = input_names.join(' | ')
      expression_header = expression_names.join(' | ')
      builder.puts("#{input_header} || #{expression_header}")

      # Rows
      results.each do |result|
        inputs_string = input_names.map { |name| output_string(result[name]).center(name.length) }.join(' | ')

        outputs_string = expression_names.map { |name| output_string(result[name]).center(name.length) }.join(' | ')
        outputs = expression_names.map { |name| result[name] }
        outputs_string = outputs.uniq.length == 1 ? outputs_string.on_green : outputs_string.on_red

        builder.puts [inputs_string, outputs_string].join(' || ')
      end

      puts builder.string
    end

    # @return [Boolean]
    def equivalent?
      results.all? { |result| result.values_at(*expression_names).uniq.length == 1 }
    end

    private

    # @param value [Object]
    # @return [String]
    def output_string(value)
      case value
      when true then '✔'
      when false then '✗'
      when nil then '-'
      else value.to_s
      end
    end

    # @param names [Array<[String]>]
    # @return [Array<Hash{String->Boolean}>]
    def input_table(names = input_names)
      return [{}] if names.empty?

      names = names.dup
      name = names.shift
      table = input_table(names)
      inputs[name].each_with_object([]) do |value, lines|
        lines.concat(table.map { |line| line.merge(name => value) })
      end
    end
  end
end
