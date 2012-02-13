class AddFieldsToPermisos < ActiveRecord::Migration
  def change
    add_column :permisos, :accion, :string
    add_index :permisos, :accion

    add_column :permisos, :controlador, :string
    add_index :permisos, :controlador
    
    add_column :permisos, :publico, :boolean
    add_index :permisos, :publico
    
    add_column :permisos, :permiso_id, :integer
    add_index :permisos, :permiso_id
  end
end
