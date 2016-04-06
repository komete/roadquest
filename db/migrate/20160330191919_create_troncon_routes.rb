class CreateTronconRoutes < ActiveRecord::Migration
  def change
    create_table :troncon_routes do |t|
      t.string :vocation
      t.string :nb_chausse
      t.string :nb_voies
      t.string :etat
      t.string :acces
      t.string :res_vert
      t.string :sens
      t.string :res_europe
      t.string :num_route
      t.string :class_adm
      t.float :longueur
      t.multi_line_string :geometry
      t.references :route, index: true, foreign_key: true
      t.references :point_repere, :point_repere_final
      t.references :point_repere,:point_repere_init

      t.timestamps null: false
    end
    add_index :troncon_routes, [:route_id, :created_at]
    add_index :troncon_routes, :geometry, :using => :gist
  end
end
