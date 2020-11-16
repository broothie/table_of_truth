require 'table_of_truth'

table = TableOfTruth.new do
  input :something_enabled?
  input :result_of_expensive_call?

  expression 'early check' do
    if result_of_expensive_call?
      something_enabled?
    else
      true
    end
  end

  expression 'late check' do
    next false if !something_enabled? && result_of_expensive_call?

    true
  end
end

table.print!      #=> prints the truth table
table.equivalent? #=> true if all expressions are equal for all input combinations
table.results     #=> get the results as an array of hashes
