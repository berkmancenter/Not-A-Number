# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100503192143) do

  create_table "answers", :force => true do |t|
    t.integer  "project_id"
    t.integer  "group_id"
    t.integer  "question_id"
    t.integer  "choice_id"
    t.integer  "user_id"
    t.integer  "saved_position"
    t.text     "answer_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
    t.integer  "code_id"
  end

  add_index "answers", ["code_id"], :name => "index_answers_on_code_id"
  add_index "answers", ["group_id"], :name => "index_answers_on_group_id"
  add_index "answers", ["project_id"], :name => "index_answers_on_project_id"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "branches", :force => true do |t|
    t.integer  "project_id"
    t.integer  "question_id"
    t.integer  "group_id"
    t.integer  "choice_id"
    t.integer  "destination_group_id"
    t.integer  "return_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["choice_id"], :name => "index_branches_on_choice_id"
  add_index "branches", ["destination_group_id"], :name => "index_branches_on_destination_group_id"
  add_index "branches", ["group_id"], :name => "index_branches_on_group_id"
  add_index "branches", ["project_id"], :name => "index_branches_on_project_id"
  add_index "branches", ["question_id"], :name => "index_branches_on_question_id"
  add_index "branches", ["return_group_id"], :name => "index_branches_on_return_group_id"

  create_table "choices", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["active"], :name => "index_choices_on_active"
  add_index "choices", ["id"], :name => "index_choices_on_id", :unique => true
  add_index "choices", ["output_text"], :name => "index_choices_on_output_text"
  add_index "choices", ["title"], :name => "index_choices_on_title"

  create_table "codes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "session_id", :limit => 1024
    t.string   "code",       :limit => 1024
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed",                  :default => false
    t.text     "meta"
  end

  create_table "group_items", :force => true do |t|
    t.integer  "group_id"
    t.integer  "question_id"
    t.text     "description"
    t.boolean  "required"
    t.integer  "position"
    t.integer  "user_id"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_items", ["group_id"], :name => "index_group_items_on_group_id"
  add_index "group_items", ["question_id"], :name => "index_group_items_on_question_id"

  create_table "groups", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outlinkURLs", :force => true do |t|
    t.string "url", :limit => 256
  end

  create_table "outlinks_report", :force => true do |t|
    t.string "username"
    t.string "target"
    t.string "1-language"
    t.string "2-primary"
    t.string "3-type"
    t.string "6-other"
    t.string "4-tags"
    t.string "5-country"
    t.string "7-notes",    :limit => 450
  end

  create_table "project_items", :force => true do |t|
    t.integer  "project_id"
    t.integer  "group_id"
    t.text     "description"
    t.integer  "position"
    t.string   "type"
    t.integer  "user_id"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_items", ["group_id"], :name => "index_project_items_on_group_id"
  add_index "project_items", ["project_id"], :name => "index_project_items_on_project_id"

  create_table "project_styles", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "meta"
  end

  create_table "question_items", :force => true do |t|
    t.integer  "question_id"
    t.integer  "choice_id"
    t.text     "description"
    t.integer  "position"
    t.integer  "user_id"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_items", ["choice_id"], :name => "index_question_items_on_choice_id"
  add_index "question_items", ["question_id"], :name => "index_question_items_on_question_id"

  create_table "question_types", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.string   "type"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "meta"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "russian_clusters", :force => true do |t|
    t.integer "unid"
    t.string  "url",     :limit => 256
    t.integer "cluster"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "target_list_items", :force => true do |t|
    t.integer  "target_list_id"
    t.integer  "target_id"
    t.text     "description"
    t.text     "notes"
    t.integer  "position"
    t.integer  "user_id"
    t.boolean  "active",         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "target_list_items", ["target_id"], :name => "index_target_list_items_on_target_id"
  add_index "target_list_items", ["target_list_id"], :name => "index_target_list_items_on_target_list_id"

  create_table "target_lists", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.text     "notes"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_types", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "targets", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "output_text", :limit => 1024
    t.text     "description"
    t.text     "notes"
    t.text     "content"
    t.integer  "user_id"
    t.string   "type"
    t.boolean  "active",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_locks", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_anonymous_string"
    t.integer  "project_id"
    t.integer  "group_id"
    t.boolean  "completed",             :default => false
    t.text     "user_meta"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
    t.integer  "code_id"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                             :null => false
    t.integer  "login_count",                    :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.integer  "allow_login",       :limit => 1, :default => 1, :null => false
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "zz_clusters", :force => true do |t|
    t.integer "order"
    t.integer "unid"
    t.string  "url"
    t.integer "cluster"
  end

  create_table "zz_data", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "code_id"
    t.string   "url"
    t.string   "q1"
    t.string   "q2"
    t.text     "q3"
    t.string   "q6"
    t.text     "q4"
    t.string   "q5"
    t.text     "q7"
    t.datetime "date_saved"
  end

  create_table "zz_data_plus", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "code_id"
    t.string   "url"
    t.string   "q95"
    t.integer  "q17"
    t.integer  "q18"
    t.string   "q49"
    t.string   "q69"
    t.string   "q20"
    t.text     "q4"
    t.text     "q7"
    t.datetime "date_saved"
  end

  create_table "zz_urls", :force => true do |t|
    t.string "item"
  end

end
