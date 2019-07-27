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

ActiveRecord::Schema.define(version: 2019_07_26_010516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "genres", force: :cascade do |t|
    t.integer "moviedbid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.integer "moviedbid"
    t.string "title"
    t.date "releasedate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "poster_path"
  end

  create_table "review_genres", force: :cascade do |t|
    t.bigint "review_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_review_genres_on_genre_id"
    t.index ["review_id"], name: "index_review_genres_on_review_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "moviedbid"
    t.string "comment"
    t.date "date"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "movie_id"
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "review_genres", "genres"
  add_foreign_key "review_genres", "reviews"
  add_foreign_key "reviews", "movies"
end
