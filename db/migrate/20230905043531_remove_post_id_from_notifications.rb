class RemovePostIdFromNotifications < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :post_id
    remove_column :notifications, :comment_id
    remove_column :notifications, :visitor_id
    remove_column :notifications, :visited_id
    remove_column :notifications, :action
    remove_column :notifications, :checked
  end
end
