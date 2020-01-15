class AddNullContraintToNotification < ActiveRecord::Migration[5.2]
  def change
    change_column_null :notifications, :customer_id, false
  end
end
