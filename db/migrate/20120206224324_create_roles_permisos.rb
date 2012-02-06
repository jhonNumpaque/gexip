class CreateRolesPermisos < ActiveRecord::Migration
  def change
    create_table :roles_permisos do |t|
      t.integer :rol_id
      t.integer :permiso_id

      t.timestamps
    end
    add_index :roles_permisos, :rol_id
    add_index :roles_permisos, :permiso_id
  end
end
