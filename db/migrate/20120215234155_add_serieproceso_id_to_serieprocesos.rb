class AddSerieprocesoIdToSerieprocesos < ActiveRecord::Migration
  def change
    add_column :serieprocesos, :serieproceso_id, :integer
    add_index :serieprocesos, :serieproceso_id

  end
end
