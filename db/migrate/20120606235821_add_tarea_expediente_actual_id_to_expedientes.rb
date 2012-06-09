class AddTareaExpedienteActualIdToExpedientes < ActiveRecord::Migration
  def change
    add_column :expedientes, :tarea_expediente_actual_id, :integer
    add_index :expedientes, :tarea_expediente_actual_id

  end
end
