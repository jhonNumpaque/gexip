class AddCargoIdToEntes < ActiveRecord::Migration
  def change
    add_column :entes, :cargo_id, :integer
    add_index :entes, :cargo_id

  end
end
