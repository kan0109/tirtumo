class AddLevelAndTotalSavingsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :total_savings, :integer
  end
end
