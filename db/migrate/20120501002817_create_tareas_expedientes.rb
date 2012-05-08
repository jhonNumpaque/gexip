class CreateTareasExpedientes < ActiveRecord::Migration
  def change
    create_table :tareas_expedientes do |t|
      t.integer :secuencia
      t.references :procedimiento
      t.references :expediente
      t.references :tarea
      t.integer :usuario_inicio_id
      t.datetime :fecha_inicio
      t.string :estado
      t.text :observacion_envio
      t.text :observacion_recepcion
      t.integer :mensajero_id
      t.integer :usuario_fin_id
      t.datetime :fecha_fin
      t.string :lote_envio

      t.timestamps
    end
    add_index :tareas_expedientes, :procedimiento_id
    add_index :tareas_expedientes, :expediente_id
    add_index :tareas_expedientes, :tarea_id
    add_index :tareas_expedientes, :usuario_inicio_id
    add_index :tareas_expedientes, :mensajero_id
    add_index :tareas_expedientes, :usuario_fin_id
  end
end
