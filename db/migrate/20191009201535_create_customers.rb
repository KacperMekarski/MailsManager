class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :email, null: false, uniqueness: true
      t.string :name, null: false
      t.string :surname, null: false
      t.timestamps
    end
  end
end
