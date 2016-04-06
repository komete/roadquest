class CreateMarquageSpecialises < ActiveRecord::Migration
  def self.up
    create_table :marquage_specialises do |t|
      t.string :type_travaux
      t.float :dimension

      t.timestamps null: false
    end
  end
  def self.down
    drop_table :marquage_specialises
  end
end
