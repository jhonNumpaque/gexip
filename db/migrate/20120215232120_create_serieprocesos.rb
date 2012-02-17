class CreateSerieprocesos < ActiveRecord::Migration
  def change
    create_table :serieprocesos do |t|
      t.string :nombre, :null => false
      t.string :clasificacion
      t.string :objetivo, :null => false
      t.string :codigo, :null => false
      t.integer :cargo_id
      t.string :type

      t.timestamps
    end
    add_index :serieprocesos, :cargo_id
    add_index :serieprocesos, :type
    add_index :serieprocesos, :codigo
  end
end
