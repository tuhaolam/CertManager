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

ActiveRecord::Schema.define(version: 20160923090500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acme_challenges", force: :cascade do |t|
    t.integer  "acme_sign_attempt_id",                       null: false
    t.string   "domain_name",                                null: false
    t.string   "last_status",          default: "unchecked", null: false
    t.json     "error_message"
    t.string   "token_key",                                  null: false
    t.string   "token_value",                                null: false
    t.string   "verification_uri",                           null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "acme_checked_at"
    t.datetime "expires_at",                                 null: false
  end

  create_table "acme_sign_attempts", force: :cascade do |t|
    t.integer  "certificate_id",                      null: false
    t.integer  "private_key_id",                      null: false
    t.integer  "imported_key_id"
    t.string   "last_status",     default: "unknown", null: false
    t.string   "status_message"
    t.string   "acme_endpoint",                       null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "last_checked_at"
  end

  create_table "agent_tags", force: :cascade do |t|
    t.integer "agent_id", null: false
    t.string  "tag",      null: false
  end

  create_table "agents", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "last_synced_at"
  end

  create_table "agents_services", force: :cascade do |t|
    t.integer "agent_id",   null: false
    t.integer "service_id", null: false
  end

  create_table "authorizations", force: :cascade do |t|
    t.integer  "o_auth_provider_id", null: false
    t.string   "identifier",         null: false
    t.string   "authorization_type", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "last_checked_at"
  end

  create_table "certificate_bundles", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "certificate_bundles_public_keys", force: :cascade do |t|
    t.integer "certificate_bundle_id", null: false
    t.integer "public_key_id",         null: false
  end

  create_table "certificate_sign_requests", force: :cascade do |t|
    t.integer "certificate_id", null: false
    t.integer "subject_id",     null: false
    t.integer "private_key_id", null: false
  end

  create_table "certificates", force: :cascade do |t|
    t.integer  "private_key_id"
    t.integer  "public_key_id"
    t.integer  "issuer_id"
    t.string   "chain_hash",                    null: false
    t.integer  "created_by_id",                 null: false
    t.integer  "updated_by_id",                 null: false
    t.integer  "inflight_acme_sign_attempt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "csr_sans", force: :cascade do |t|
    t.integer "certificate_sign_request_id", null: false
    t.integer "subject_alternate_name_id",   null: false
  end

  create_table "key_usages", force: :cascade do |t|
    t.integer "public_key_id", null: false
    t.string  "value",         null: false
    t.string  "group",         null: false
  end

  create_table "o_auth_providers", force: :cascade do |t|
    t.string "name",               null: false
    t.string "requested_scopes",   null: false
    t.string "authorize_uri_base", null: false
    t.string "token_uri_base",     null: false
    t.string "client_id"
    t.string "client_secret"
    t.index ["name"], name: "index_o_auth_providers_on_name", unique: true, using: :btree
  end

  create_table "private_keys", force: :cascade do |t|
    t.string   "type",        null: false
    t.integer  "bit_length"
    t.string   "curve_name"
    t.string   "fingerprint", null: false
    t.binary   "body",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["fingerprint"], name: "index_private_keys_on_fingerprint", using: :btree
  end

  create_table "public_keys", force: :cascade do |t|
    t.integer  "subject_id",                        null: false
    t.integer  "private_key_id"
    t.integer  "issuer_subject_id"
    t.integer  "certificate_id"
    t.string   "type",                              null: false
    t.string   "curve_name"
    t.string   "hash_algorithm",                    null: false
    t.integer  "bit_length"
    t.boolean  "is_ca",             default: false, null: false
    t.datetime "not_before",                        null: false
    t.datetime "not_after",                         null: false
    t.bigint   "serial",                            null: false
    t.binary   "body",                              null: false
    t.string   "fingerprint"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["fingerprint"], name: "index_public_keys_on_fingerprint", using: :btree
  end

  create_table "public_keys_sans", force: :cascade do |t|
    t.integer "public_key_id",             null: false
    t.integer "subject_alternate_name_id", null: false
  end

  create_table "revocation_endpoints", force: :cascade do |t|
    t.integer "public_key_id", null: false
    t.string  "endpoint",      null: false
    t.string  "uri_type",      null: false
  end

  create_table "services", force: :cascade do |t|
    t.string   "type",           null: false
    t.integer  "certificate_id", null: false
    t.json     "properties",     null: false
    t.datetime "last_deployed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "config_group", null: false
    t.string   "key",          null: false
    t.string   "value",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "subject_alternate_names", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "CN"
    t.string "O"
    t.string "OU"
    t.string "C"
    t.string "ST"
    t.string "L"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                                   null: false
    t.string   "first_name",                                              null: false
    t.string   "last_name",                                               null: false
    t.binary   "password_hash",                                           null: false
    t.binary   "password_salt",                                           null: false
    t.boolean  "can_login",                     default: false,           null: false
    t.string   "time_zone",                     default: "Europe/London", null: false
    t.boolean  "lets_encrypt_accepted_terms",   default: false,           null: false
    t.string   "lets_encrypt_registration_uri"
    t.integer  "github_userid"
    t.string   "github_username"
    t.string   "github_access_token"
    t.string   "github_scope"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0,               null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "certificate_bundles_public_keys", "certificate_bundles", on_delete: :cascade
  add_foreign_key "certificate_bundles_public_keys", "public_keys"
  add_foreign_key "certificates", "private_keys"
  add_foreign_key "certificates", "public_keys"
  add_foreign_key "services", "certificates"
end
