class CreateCargosEntes < ActiveRecord::Migration
  def change
    create_table :cargos_entes do |t|
      t.integer :cargo_id
      t.integer :ente_id

      t.timestamps
    end
    add_index :cargos_entes, :cargo_id
    add_index :cargos_entes, :ente_id
    add_index :cargos_entes, [:ente_id, :cargo_id]
  end
end
