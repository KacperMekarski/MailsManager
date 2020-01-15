class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.datetime :send_at, comment: 'date of sending email'
      t.datetime :read_at, comment: 'date of reading email'
      t.date :payment_deadline_on, comment: 'payment final date'
      t.decimal :tax_amount, null: false, comment: 'amount of money to pay for tax'
      t.boolean :delivered, comment: 'whether email was delivered or not'
      t.boolean :read, comment: 'whether email was read or not'
      t.timestamps
    end
    add_reference :notifications, :customer, foreign_key: true
  end
end
