class CreateMarquageLineaires < ActiveRecord::Migration
  def self.up
    create_table :marquage_lineaires do |t|
      t.float :largeur_bande

      t.timestamps null: false
    end
  end
  def self.down
    drop_table :marquage_lineaires
  end
end
