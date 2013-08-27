class TiempoDemorado
  attr_accessor :cid, :cnumero, :cfecha_inicio, :cminutos_demorados, :cminutos_estimados, :cminutos, :cfuncionario
  def initialize(cid, cnumero, cfecha_inicio, cminutos_demorados, cminutos_estimados, cminutos, cfuncionario)

      @cid = cid
      @cnumero = cnumero
      @cfecha_inicio = cfecha_inicio
      @cminutos_demorados = cminutos_demorados
      @cminutos_estimados = cminutos_estimados
      @cminutos = cminutos
      @cfuncionario = cfuncionario

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

        result.map { |r| TiempoDemorado.new(r["cid"], r["cnumero"], r["cfecha_inicio"], r["cminutos_demorados"], r["cminutos_estimados"], r["cminutos"], r["cfuncionario"]) }
    end
  end
  
  class << self
    def f_reporte_602(fecha1,fecha2,cargo_id)
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_602('#{fecha1}','#{fecha2}','#{cargo_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["cid"], r["cnumero"], r["cfecha_inicio"], r["cminutos_demorados"], r["cminutos_estimados"], r["cminutos"], r["cfuncionario"]) }
    end
  end

  class << self
    def f_reporte_603(fecha1,fecha2,pi_funcionario_id)
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_603('#{fecha1}','#{fecha2}','#{pi_funcionario_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["cid"], r["cnumero"], r["cfecha_inicio"], r["cminutos_demorados"], r["cminutos_estimados"], r["cminutos"], r["cfuncionario"]) }
    end
  end

  class << self
    def f_reporte_604(fecha1,fecha2,procedimineto_id)
      #result = ActiveRecord::Base.connection.execute("SELECT * FROM stock_hourly_performance(#{stock_id})")
      #RETURNS TABLE(ctiempo double precision, cnombres character varying, capellidos character varying) AS
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_604('#{fecha1}','#{fecha2}','#{procedimineto_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["cid"], r["cnumero"], r["cfecha_inicio"], r["cminutos_demorados"], r["cminutos_estimados"], r["cminutos"], r["cfuncionario"]) }
    end
  end
  
  class << self
    def f_reporte_605(fecha1,fecha2,cargo_id)
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_605('#{fecha1}','#{fecha2}','#{cargo_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["cid"], r["cnumero"], r["cfecha_inicio"], r["cminutos_demorados"], r["cminutos_estimados"], r["cminutos"], r["cfuncionario"]) }
    end
  end

  class << self
    def f_reporte_606(fecha1,fecha2,pi_funcionario_id)
      result = ActiveRecord::Base.connection.execute(" SELECT * FROM f_reporte_606('#{fecha1}','#{fecha2}','#{pi_funcionario_id}') ")

      if result.count == 0
        #return [TiempoDemorado.new(0, "N/A", "N/A")]
        return nil
      end

        result.map { |r| TiempoDemorado.new(r["cid"], r["cnumero"], r["cfecha_inicio"], r["cminutos_demorados"], r["cminutos_estimados"], r["cminutos"], r["cfuncionario"]) }
    end
  end

end