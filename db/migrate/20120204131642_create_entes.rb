class CreateEntes < ActiveRecord::Migration
  def change
    create_table :entes do |t|
      t.string :nombre
      t.string :apellido
      t.string :documento
      t.string :tipo_documento
      t.string :direccion
      t.string :telefono
      t.integer :territorio_id

      t.timestamps
    end
    add_index :entes, :territorio_id
    add_index :entes, :documento
  end
end
