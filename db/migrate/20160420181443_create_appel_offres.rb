class CreateAppelOffres < ActiveRecord::Migration
  def change
    create_table :appel_offres do |t|
      t.date :date, :null => false, :default => Time.zone.today
      t.float :budget
      t.string :periode
      t.text :description
      t.string :document_annexe
      t.boolean :assigned , :null => false, :default => true
      t.references :entrepreneur, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :appel_offres, [:entrepreneur_id, :created_at]
  end
end
