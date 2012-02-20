class AddSerieProcesoIdToProcedimientos < ActiveRecord::Migration
  def change
    add_column :procedimientos, :serieproceso_id, :integer
    add_index :procedimientos, :serieproceso_id

  end
end
