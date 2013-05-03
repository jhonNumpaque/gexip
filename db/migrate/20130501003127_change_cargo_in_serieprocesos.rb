class ChangeCargoInSerieprocesos < ActiveRecord::Migration
  def change
  	remove_column :serieprocesos, :cargo_id
  	add_column :serieprocesos, :cargo_ente_id, :integer
  end
end
