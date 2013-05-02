class CreatePersonasFisicas < ActiveRecord::Migration
  def change
    create_table :personas_fisicas do |t|
      t.string :nombre
      t.string :apellido
      t.string :documento
      t.string :direccion
      t.string :telefono
      t.integer :territorio_id
      t.integer :tipo_documento_id
      t.integer :cargo_ente_id

      t.timestamps
    end
    add_index :personas_fisicas, :territorio_id
    add_index :personas_fisicas, :tipo_documento_id
    add_index :personas_fisicas, :cargo_ente_id
  end
end
