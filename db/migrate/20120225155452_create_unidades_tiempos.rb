class CreateUnidadesTiempos < ActiveRecord::Migration
  def change
    create_table :unidades_tiempos do |t|
      t.string :nombre
      t.string :simbolo

      t.timestamps
    end
  end
end
