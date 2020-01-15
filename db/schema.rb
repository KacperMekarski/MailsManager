# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_191_215_160_512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'customers', force: :cascade do |t|
    t.string 'email', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'fullname', null: false
  end

  create_table 'notifications', force: :cascade do |t|
    t.date 'send_at', null: false, comment: 'date of sending email'
    t.datetime 'read_at', comment: 'date of reading email'
    t.date 'payment_deadline_on', comment: 'payment final date'
    t.decimal 'tax_amount', null: false, comment: 'amount of money to pay for tax'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'customer_id', null: false
    t.bigint 'sheet_id', null: false
    t.string 'period', null: false
    t.datetime 'delivered_at'
    t.index ['customer_id'], name: 'index_notifications_on_customer_id'
    t.index ['sheet_id'], name: 'index_notifications_on_sheet_id'
  end

  create_table 'sheets', force: :cascade do |t|
    t.string 'title'
    t.bigint 'sheet_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'versions', force: :cascade do |t|
    t.string 'item_type', null: false
    t.bigint 'item_id', null: false
    t.string 'event', null: false
    t.string 'whodunnit'
    t.text 'object'
    t.datetime 'created_at'
    t.index %w[item_type item_id], name: 'index_versions_on_item_type_and_item_id'
  end

  add_foreign_key 'notifications', 'customers'
end
