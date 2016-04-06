class CreatePointReperes < ActiveRecord::Migration
  def change
    create_table :point_reperes do |t|
      t.float :latitude
      t.float :longitude
      t.string :projection

      t.timestamps null: false
    end
  end
end
