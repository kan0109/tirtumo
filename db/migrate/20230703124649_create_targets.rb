class CreateTargets < ActiveRecord::Migration[7.0]
  def change
    create_table :targets do |t|
      t.references :user, foreign_key: true
      t.string :target
      t.integer :target_amount
      t.timestamps
    end
  end
end
