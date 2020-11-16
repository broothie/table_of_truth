# Table of Truth

A gem for comparing boolean expressions.

## Usage

Create a table:
```ruby
# Require the gem
require 'table_of_truth'

table = TableOfTruth.new do
  # Define inputs
  input :something_enabled?
  input :result_of_expensive_call?

  # Define an expression
  expression 'early check' do
    if result_of_expensive_call?
      something_enabled?
    else
      true
    end
  end

  # Define another expression
  expression 'late check' do
    next false if !something_enabled? && result_of_expensive_call?

    true
  end
end
```

then, print the table:
```ruby
table.print! # outputs the following:
# something_enabled? | expensive_call_to_service? || early check | late check
#         ✗          |             ✗              ||      ✔      |     ✔
#         ✗          |             ✔              ||      ✗      |     ✗
#         ✔          |             ✗              ||      ✔      |     ✔
#         ✔          |             ✔              ||      ✔      |     ✔
```

or, check equivalency:
```ruby
table.equivalent? #=> true if all expressions are equal for all input combinations
```
