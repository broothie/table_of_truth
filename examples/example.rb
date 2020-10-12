require 'table-of-truth'

table = TruthTable.new do
  input :enabled?
  input :available?

  expression :early_check do |inputs|
    if inputs[:enabled?]
      inputs[:available?]
    else
      true
    end
  end

  expression :late_check do |inputs|
    next false if !inputs[:available?] && inputs[:enabled?]

    true
  end
end

table.print!
puts "equivalent: #{table.equivalent?}"
