module InformesHelper


#[['Authors', ['Jose', 'Carlos']], ['General', ['Bob', 'John']]]
  def get_funcionarios_group
    result = {}
    funcionario = Funcionario.all

    funcionario.each do |r|
      result[CargoEstructura.find(r.cargo_estructura_id).cargo.nombre + " " + CargoEstructura.find(r.cargo_estructura_id).estructura.nombre] ||= {}
      result[CargoEstructura.find(r.cargo_estructura_id).cargo.nombre + " " + CargoEstructura.find(r.cargo_estructura_id).estructura.nombre][r.nombre_completo] = r.id
    end

    return result
  end

  def get_procedimientos_group
    result = {}
    procedimiento = Procedimiento.all
    procedimiento.each do |p|
      begin
        subproceso = Subproceso.find(p.serieproceso_id)
        serieproceso = subproceso.nombre
      rescue
        proceso = Proceso.find(p.serieproceso_id)
        serieproceso = proceso.nombre
      end


      result[serieproceso] ||= {}
      result[serieproceso][p.nombre] = p.id
    end

    return result
  end

  def get_tiempo_duracion_group
    duracion = {
        'Menor a una hora' => '60',
        'Mayor a una hora' => '60',
        'Un Dia' => '60',
    }

  end

end
