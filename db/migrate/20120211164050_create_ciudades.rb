class CreateCiudades < ActiveRecord::Migration
  def change
    create_table :ciudades do |t|
      t.string :nombre
      t.string :type
      t.integer :territorio_id

      t.timestamps
    end
  end
end
