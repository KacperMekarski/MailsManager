class UpdateCustomer < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :name, :string
    remove_column :customers, :surname, :string
    add_column :customers, :fullname, :string, null: false
  end
end
