class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :num_route

      t.timestamps null: false
    end
  end
end
