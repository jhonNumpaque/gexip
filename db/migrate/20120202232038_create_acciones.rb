class CreateAcciones < ActiveRecord::Migration
  def change
    create_table :acciones do |t|
      t.string :accion

      t.timestamps
    end
  end
end
