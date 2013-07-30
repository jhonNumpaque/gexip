class TiempoDemorado
  attr_accessor :ctiempo, :cnombres, :capellidos
  def initialize(ctiempo, cnombres, capellidos)
      @ctiempo = ctiempo
      @cnombres = cnombres
      @capellidos = capellidos
  end
  
  class << self
    def f_reporte_601(fecha1,fecha2,procedimineto_id)
      #result = ActiveRecord::Base.connection.execute("SELECT * FROM stock_hourly_performance(#{stock_id})")
      #RETURNS TABLE(ctiempo double precision, cnombres character varying, capellidos character varying) AS
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_601('#{fecha1}','#{fecha2}','#{procedimineto_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["ctiempo"], r["cnombres"], r["capellidos"]) }        
    end
  end
  
  class << self
    def f_reporte_602(fecha1,fecha2,cargo_id)
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_602('#{fecha1}','#{fecha2}','#{cargo_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["ctiempo"], r["cnombres"], r["capellidos"]) }        
    end
  end

end