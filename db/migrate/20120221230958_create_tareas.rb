class CreateTareas < ActiveRecord::Migration
  def change
    create_table :tareas do |t|
      t.integer :orden, :null => false
      t.string :nombre, :null => false
      t.string :metodo
      t.integer :tiempo_ejecucion
      t.integer :unidad_tiempo_id
      #tipo INICIO, PROCESO, TRANSLADO, ALMACENAMIENTO, LOGICA(CONDICIONAL), FINAL
      t.string :tipo, :null => false
      t.integer :actividad_id, :null => false
      t.integer :procedimiento_asoc_id
      t.integer :cargo_id, :null => false
      t.integer :tarea_sgt_id
      t.integer :tarea_alt_id

      t.timestamps
    end
    add_index :tareas, :cargo_id
    add_index :tareas, :tarea_sgt_id #para camino normal
    add_index :tareas, :tarea_alt_id #para camino alternativo, puede ser exepciones
    add_index :tareas, :actividad_id
    add_index :tareas, :procedimiento_asoc_id
    add_index :tareas, :tipo
  end
end
