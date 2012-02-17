class CreateActividades < ActiveRecord::Migration
  def change
    create_table :actividades do |t|
      t.string :descripcion
      t.integer :orden

      t.timestamps
    end
  end
end
