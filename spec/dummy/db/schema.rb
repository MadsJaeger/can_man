# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_12_074008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rights", primary_key: "key", id: :string, comment: "List of controller actions to be linked to users as her rights", force: :cascade do |t|
    t.string "name", comment: "Name of the right, descriptive name potentially to be used in the UI"
    t.text "description", comment: "Description of the right, potentially to be used in the UI"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_rights_on_key", unique: true
  end

  create_table "role_rights", comment: "Join between roles and rights", force: :cascade do |t|
    t.string "role_key", null: false
    t.string "right_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["right_key"], name: "index_role_rights_on_right_key"
    t.index ["role_key", "right_key"], name: "index_role_rights_on_role_key_and_right_key", unique: true
    t.index ["role_key"], name: "index_role_rights_on_role_key"
  end

  create_table "roles", primary_key: "key", id: :string, comment: "Collection of rights", force: :cascade do |t|
    t.string "name", comment: "Name of the role"
    t.text "description", comment: "Description of the role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", comment: "Join between user and roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "role_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_key"], name: "index_user_roles_on_role_key"
    t.index ["user_id", "role_key"], name: "index_user_roles_on_user_id_and_role_key", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false, comment: "Name of the user"
    t.string "email", null: false, comment: "Email of the user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "role_rights", "rights", column: "right_key", primary_key: "key", on_delete: :cascade
  add_foreign_key "role_rights", "roles", column: "role_key", primary_key: "key", on_delete: :cascade
  add_foreign_key "user_roles", "roles", column: "role_key", primary_key: "key", on_delete: :cascade
  add_foreign_key "user_roles", "users"
end
