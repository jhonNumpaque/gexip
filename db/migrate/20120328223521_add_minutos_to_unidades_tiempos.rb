class AddMinutosToUnidadesTiempos < ActiveRecord::Migration
  def change
    add_column :unidades_tiempos, :minutos, :decimal

  end
end
