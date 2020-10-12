require 'colorize'
require 'stringio'
require_relative 'table_dsl'

class TruthTable
  # @return [Hash<(String or Symbol)->Array>]
  attr_reader :inputs
  # @return [Array<String or Symbol>]
  attr_reader :input_names
  # @return [Hash<(String or Symbol)->Proc>]
  attr_reader :expressions
  # @return [Array<String or Symbol>]
  attr_reader :expression_names

  def initialize(&block)
    dsl = TableDsl.new
    dsl.instance_eval(&block)

    @inputs = dsl.inputs
    @input_names = dsl.input_names
    @expressions = dsl.expressions
    @expression_names = dsl.expression_names
  end

  # @return [void]
  def print!
    builder = StringIO.new

    # Header
    builder.puts [input_names, expression_names].map { |sides| sides.join(' | ') }.join(' || ')

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

  def output_string(value)
    case value
    when true then '✔'
    when false then '✗'
    when nil then '-'
    else value.to_s
    end
  end

  # @return [Boolean]
  def equivalent?
    results.all? { |result| result.values_at(*expression_names).uniq.length == 1 }
  end

  # @return [Array<Hash{String->Boolean}>]
  def results
    @results ||= input_table.each_with_object([]) do |inputs, results|
      result = inputs.dup
      expressions.each { |name, expression| result[name] = expression.call(result) }

      results << result
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
