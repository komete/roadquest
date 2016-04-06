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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160403140953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "entrepreneurs", force: :cascade do |t|
    t.string   "ref_entreprise"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "marquage_lineaires", force: :cascade do |t|
    t.float    "largeur_bande"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "marquage_specialises", force: :cascade do |t|
    t.string   "type_travaux"
    t.float    "dimension"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "marquages", force: :cascade do |t|
    t.integer  "actable_id"
    t.string   "actable_type"
    t.string   "type_marquage"
    t.string   "couleur"
    t.integer  "work_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "marquages", ["work_id", "created_at"], name: "index_marquages_on_work_id_and_created_at", using: :btree
  add_index "marquages", ["work_id"], name: "index_marquages_on_work_id", using: :btree

  create_table "point_reperes", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "projection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "produits", force: :cascade do |t|
    t.string   "nom"
    t.string   "type_produit"
    t.date     "expiration"
    t.string   "reference"
    t.integer  "marquage_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "produits", ["marquage_id", "created_at"], name: "index_produits_on_marquage_id_and_created_at", using: :btree
  add_index "produits", ["marquage_id"], name: "index_produits_on_marquage_id", using: :btree

  create_table "routes", force: :cascade do |t|
    t.string   "num_route"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "troncon_route", force: :cascade do |t|
    t.integer  "id_rte500"
    t.string   "vocation"
    t.string   "nb_chausse"
    t.string   "nb_voies"
    t.string   "etat"
    t.string   "acces"
    t.string   "res_vert"
    t.string   "sens"
    t.string   "res_europe"
    t.string   "num_route"
    t.string   "class_adm"
    t.float    "longueur"
    t.geometry "the_geom",   limit: {:srid=>0, :type=>"multi_line_string"}
  end

  create_table "troncon_routes", force: :cascade do |t|
    t.string   "vocation"
    t.string   "nb_chausse"
    t.string   "nb_voies"
    t.string   "etat"
    t.string   "acces"
    t.string   "res_vert"
    t.string   "sens"
    t.string   "res_europe"
    t.string   "num_route"
    t.string   "class_adm"
    t.float    "longueur"
    t.geometry "geometry",              limit: {:srid=>0, :type=>"multi_line_string"}
    t.integer  "route_id"
    t.integer  "point_repere_id"
    t.integer  "point_repere_final_id"
    t.integer  "point_repere_init_id"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "troncon_routes", ["geometry"], name: "index_troncon_routes_on_geometry", using: :gist
  add_index "troncon_routes", ["route_id", "created_at"], name: "index_troncon_routes_on_route_id_and_created_at", using: :btree
  add_index "troncon_routes", ["route_id"], name: "index_troncon_routes_on_route_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "utilisateur_id"
    t.string   "utilisateur_type"
    t.string   "nom"
    t.string   "prenom"
    t.string   "email"
    t.integer  "poste"
    t.string   "codeEmploye"
    t.string   "telephone"
    t.string   "username"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "password_digest"
    t.string   "verified_digest"
    t.boolean  "verified",         default: false
    t.datetime "verified_at"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_at"
    t.boolean  "administrateur",   default: false
  end

  create_table "works", force: :cascade do |t|
    t.string   "type_work"
    t.text     "description"
    t.date     "debut",            default: '2016-04-06', null: false
    t.date     "fin"
    t.string   "intervenant"
    t.integer  "troncon_route_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "works", ["troncon_route_id", "created_at"], name: "index_works_on_troncon_route_id_and_created_at", using: :btree
  add_index "works", ["troncon_route_id"], name: "index_works_on_troncon_route_id", using: :btree

  add_foreign_key "marquages", "works"
  add_foreign_key "produits", "marquages"
  add_foreign_key "troncon_routes", "routes"
  add_foreign_key "works", "troncon_routes"
end
