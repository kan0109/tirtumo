class AddColumnsToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :user, foreign_key: true
    add_reference :notifications, :subject, polymorphic: true
    add_column :notifications, :action_type, :integer, null: false
    add_column :notifications, :read, :boolean, null: false, default: false
  end
end