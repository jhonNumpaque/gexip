class AddSerieprocesosCountToSerieprocesos < ActiveRecord::Migration
  def change
    add_column :serieprocesos, :serieprocesos_count, :integer
    add_column :serieprocesos, :procedimientos_count, :integer

    Serieproceso.reset_column_information
    Serieproceso.all.each do |s|
    	Serieproceso.update_counters s.id, serieprocesos_count: s.serieprocesos.length
    	Serieproceso.update_counters s.id, procedimientos_count: s.procedimientos.length
    end
  end
end
