class CreateAdjuntos < ActiveRecord::Migration
  def change
    create_table :adjuntos do |t|
      t.string :data
      t.string :file_size
      t.string :content_type
      t.integer :adjuntable_id
      t.string :adjuntable_type

      t.timestamps
    end
    add_index :adjuntos, :adjuntable_type
    add_index :adjuntos, :adjuntable_id
  end
end
