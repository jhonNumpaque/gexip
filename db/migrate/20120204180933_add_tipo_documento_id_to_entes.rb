class AddTipoDocumentoIdToEntes < ActiveRecord::Migration
  def change
    add_column :entes, :tipo_documento_id, :integer
    add_index :entes, :tipo_documento_id

  end
end
