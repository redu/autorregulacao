# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130120112816) do

  create_table "answers", :force => true do |t|
    t.text     "initial"
    t.text     "rationale"
    t.text     "reflection"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "ar_exercises", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ar_exercises", ["user_id"], :name => "index_ar_exercises_on_user_id"

  create_table "cooperations", :force => true do |t|
    t.text     "rationale"
    t.text     "recommendation"
    t.text     "feedback_statement"
    t.text     "feedback_reflection"
    t.boolean  "feedback_accepted"
    t.integer  "user_id"
    t.integer  "answer_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "cooperations", ["answer_id"], :name => "index_cooperations_on_answer_id"
  add_index "cooperations", ["user_id"], :name => "index_cooperations_on_user_id"

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.text     "statement"
    t.integer  "ar_exercise_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "questions", ["ar_exercise_id"], :name => "index_questions_on_ar_exercise_id"

  create_table "spaces", :force => true do |t|
    t.integer  "core_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "login"
    t.string   "name"
    t.string   "token"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
