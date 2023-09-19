class RemoveColumnsFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_reference :notifications, :user, foreign_key: true
    remove_reference :notifications, :subject, polymorphic: true
    remove_column :notifications, :action_type
    remove_column :notifications, :read
  end
end
