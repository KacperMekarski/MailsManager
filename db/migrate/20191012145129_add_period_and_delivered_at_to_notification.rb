class AddPeriodAndDeliveredAtToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :period, :string, null: false
    add_column :notifications, :delivered_at, :datetime
    change_column :notifications, :send_at, :date, null: false
  end
end
