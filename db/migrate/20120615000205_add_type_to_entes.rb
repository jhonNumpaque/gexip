class AddTypeToEntes < ActiveRecord::Migration
  def change
    add_column :entes, :type, :string
    add_index :entes, :type

  end
end
