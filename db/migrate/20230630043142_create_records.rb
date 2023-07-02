class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.references :user, foreign_key: true
      t.boolean :bottle_bring, default: false
      t.boolean :packed_lunch, default: false
      t.boolean :alternative_transportation, default: false
      t.boolean :no_eating_out, default: false
      t.timestamps
    end
  end
end
