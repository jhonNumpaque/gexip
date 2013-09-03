class CreateVersionesAprobadas < ActiveRecord::Migration
  def change
    create_table :versiones_aprobadas do |t|
      t.string :tipo_item
      t.integer :version_id
      t.integer :item_id
      t.integer :secuencia
      t.boolean :activo, :default => true

      t.timestamps
    end
		add_index :versiones_aprobadas, [:item_id, :tipo_item]
  end
end
