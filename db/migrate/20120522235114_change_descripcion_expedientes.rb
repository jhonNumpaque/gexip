class ChangeDescripcionExpedientes < ActiveRecord::Migration 
 
  def up      
     change_column :expedientes, :descripcion, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
