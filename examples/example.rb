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

table.print!
table.equivalent? # true or false, depending of whether expressions are equal for all input combinations
