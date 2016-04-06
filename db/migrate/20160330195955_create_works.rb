class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :type_work
      t.text :description
      t.date :debut, :null => false, :default => Time.zone.today
      t.date :fin
      t.string :intervenant
      t.references :troncon_route, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :works, [:troncon_route_id, :created_at]
  end
end
