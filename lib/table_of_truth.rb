require_relative 'table_of_truth/table'

module TableOfTruth
  def self.new(&block)
    Table.new(&block)
  end
end
