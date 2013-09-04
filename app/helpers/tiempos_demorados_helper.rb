# encoding:utf-8
module TiemposDemoradosHelper

  # Pasados los minutos retorna la cantidad de tiempo transcurrido en español
  # Ejemplo: 2 años 9 meses 13 dias 5 horas 3 minutos
  def tiempo_letra(p_minutos)
    minutos = p_minutos.to_i #es el numero total de minutos
    horas = (minutos/60).to_i #numero total de horas
    dias = (horas/24).to_i # numero total de di­as
    meses = (dias/30).to_i # numero total de meses
    s_anos = (meses/12).to_i # numero total de años

    #modulamos los tiempos
    s_minutos = (minutos%60).to_i
    s_horas = (horas%24).to_i
    s_dias = (dias%30).to_i
    s_meses = (meses%12).to_i

    resultado = ""
    if(s_anos>0)
      if(s_anos>1)
        resultado = resultado + "#{s_anos} años "
      else
        resultado = resultado + "#{s_anos} año "
      end
    end
    if(s_meses>0)
      if(s_meses>1)
        resultado = resultado + "#{s_meses} meses "
      else
        resultado = resultado + "#{s_meses} mes "
      end
    end
    if(s_dias>0)
      if(s_dias>1)
        resultado = resultado + "#{s_dias} dias "
      else
        resultado = resultado + "#{s_dias} dia "
      end
    end
    if(s_horas>0)
      if(s_horas>1)
        resultado = resultado + "#{s_horas} horas "
      else
        resultado = resultado + "#{s_horas} hora "
      end
    end
    if(s_minutos>0)
      if(s_minutos>1)
        resultado = resultado + "#{s_minutos} minutos "
      else
        resultado = resultado + "#{s_minutos} minuto "
      end
    end

    return resultado
  end

end
