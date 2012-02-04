class CreateTiposDocumentos < ActiveRecord::Migration
  def change
    create_table :tipos_documentos do |t|
      t.string :nombre
      t.string :formato

      t.timestamps
    end
  end
end
