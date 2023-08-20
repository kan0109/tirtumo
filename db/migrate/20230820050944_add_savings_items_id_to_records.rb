class AddSavingsItemsIdToRecords < ActiveRecord::Migration[7.0]
  def change
    add_reference :records, :savings_item, foreign_key: true
  end
end
