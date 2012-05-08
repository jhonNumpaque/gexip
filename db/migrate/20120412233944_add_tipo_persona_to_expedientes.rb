class AddTipoPersonaToExpedientes < ActiveRecord::Migration
  def change
    add_column :expedientes, :tipo_persona, :string

  end
end
