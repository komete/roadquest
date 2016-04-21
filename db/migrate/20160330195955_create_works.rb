class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :type_work
      t.text :description
      t.date :debut, :null => false, :default => Time.zone.today
      t.date :fin
      t.string :intervenant
      t.st_point :lonlat , geographic: true
      t.references :troncon_route, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :works, [:troncon_route_id, :created_at]
    add_index :works, :lonlat, :using => :gist
  end
end
