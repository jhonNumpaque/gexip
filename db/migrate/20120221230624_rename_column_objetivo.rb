class RenameColumnObjetivo < ActiveRecord::Migration
  def change
		change_column :serieprocesos, :objetivo, :text 
  end

end
