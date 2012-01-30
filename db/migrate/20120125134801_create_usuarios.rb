class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :login, :null => false
      t.string :nombres, :null => false
      t.string :apellidos, :null => false
      t.string :documento, :null => false
      t.integer :ente_id
      t.integer :rol_id

      # devise
      t.database_authenticatable  :null => false
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both

      t.timestamps
    end

    add_index :usuarios, :documento, :unique => true
    add_index :usuarios, :ente_id
    add_index :usuarios, :rol_id
    add_index :usuarios, :login,     :unique => true
    add_index :usuarios, :email,     :unique => true
  end
end
