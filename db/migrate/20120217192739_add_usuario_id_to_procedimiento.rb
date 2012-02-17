class AddUsuarioIdToProcedimiento < ActiveRecord::Migration
  def change
    add_index :procedimientos, :elabora_usuario
    add_index :procedimientos, :revisado_usuario
    add_index :procedimientos, :aprobado_usuario
  end
end
