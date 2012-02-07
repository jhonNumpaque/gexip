class CreateTerritorios < ActiveRecord::Migration
  def change
    create_table :territorios do |t|
      t.string :nombre, :null => false
      t.string :type, :null => false
      t.integer :territorio_id

      t.timestamps
    end
    add_index :territorios, :territorio_id
    add_index :territorios, :type
  end
end
