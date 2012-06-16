class CreatePersonasJuridicas < ActiveRecord::Migration
  def change
    create_table :personas_juridicas do |t|
      t.string :nombre
      t.string :apellido
      t.string :documento
      t.string :direccion
      t.string :telefono
      t.number :territorio_id
      t.number :cargo_id

      t.timestamps
    end
  end
end
