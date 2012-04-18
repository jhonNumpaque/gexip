class CreateExpedientes < ActiveRecord::Migration
  def change
    create_table :expedientes do |t|
      t.integer :proceso_id
      t.integer :procedimiento_id, :null => false
      t.integer :tarea_actual_id
      t.integer :tarea_anterior_id
      t.integer :ente_id, :null => false
      t.integer :usuario_id, :null => false
      t.string :descripcion
      t.string :observacion
      t.string :observacion_fin
      t.string :estado
      t.integer :usuario_ingreso_id, :null => false
      t.datetime :fecha_ingreso, :null => false
      t.integer :usuario_finalizo_id
      t.datetime :fecha_finalizo
      t.integer :numero, :null => false, :limit => 8
      t.boolean :copia, :default => 'false'

      t.timestamps
    end
    add_index :expedientes, :procedimiento_id
    add_index :expedientes, :tarea_actual_id
    add_index :expedientes, :estado
    add_index :expedientes, :fecha_ingreso
    add_index :expedientes, :fecha_finalizo
  end
end
