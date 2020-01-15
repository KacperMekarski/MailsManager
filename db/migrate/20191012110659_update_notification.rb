class UpdateNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :sheet, index: true, null: false
    remove_column :notifications, :delivered
    remove_column :notifications, :read
  end
end
