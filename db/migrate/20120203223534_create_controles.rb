class CreateControles < ActiveRecord::Migration
  def change
    create_table :controles do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
