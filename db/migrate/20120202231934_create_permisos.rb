class CreatePermisos < ActiveRecord::Migration
  def change
    create_table :permisos do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
