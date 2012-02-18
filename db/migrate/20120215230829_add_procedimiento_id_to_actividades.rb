class AddProcedimientoIdToActividades < ActiveRecord::Migration
  def change
    add_column :actividades, :procedimiento_id, :integer
    add_index :actividades, :procedimiento_id

  end
end
