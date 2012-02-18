class CreateProcedimientos < ActiveRecord::Migration
  def change
    create_table :procedimientos do |t|
      t.string :nombre
      t.string :objetivo
      t.string :definiciones
      t.date :elabora_fecha
      t.integer :elabora_usuario
      t.date :revisado_fecha
      t.integer :revisado_usuario
      t.date :aprobado_fecha
      t.integer :aprobado_usuario

      t.timestamps
    end
  end
end
