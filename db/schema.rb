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

ActiveRecord::Schema[8.0].define(version: 2025_07_26_151025) do
  create_table "projects", force: :cascade do |t|
    t.string "code"
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_projects_on_code", unique: true
  end

  create_table "rank_items", force: :cascade do |t|
    t.string "type"
    t.integer "ranking_board_id", null: false
    t.float "score", null: false
    t.string "name"
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ranking_board_id"], name: "index_rank_items_on_ranking_board_id"
    t.index ["score"], name: "index_rank_items_on_score"
    t.index ["uid"], name: "index_rank_items_on_uid", unique: true
    t.index ["updated_at"], name: "index_rank_items_on_updated_at"
  end

  create_table "ranking_boards", force: :cascade do |t|
    t.string "type"
    t.integer "project_id", null: false
    t.integer "num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "num"], name: "index_ranking_boards_on_project_id_and_num", unique: true
    t.index ["project_id"], name: "index_ranking_boards_on_project_id"
  end

  create_table "recent_rank_items", force: :cascade do |t|
    t.integer "ranking_board_id", null: false
    t.float "score", null: false
    t.string "uid", null: false
    t.boolean "new_record_score", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ranking_board_id"], name: "index_recent_rank_items_on_ranking_board_id"
    t.index ["score"], name: "index_recent_rank_items_on_score"
    t.index ["uid"], name: "index_recent_rank_items_on_uid", unique: true
  end

  add_foreign_key "rank_items", "ranking_boards"
  add_foreign_key "ranking_boards", "projects"
  add_foreign_key "recent_rank_items", "ranking_boards"
end
