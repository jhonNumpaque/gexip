# encoding: utf-8
module ExpedientesHelper
  def link_iniciar_tarea(expediente)
    if expediente.tarea_expediente_actual.finalizado?
      clase = 'btn btn-primary'
    else
      clase = 'btn'
      disabled = 'disabled'
    end

    link_to(icon_tag('Inicar', class: 'icon-play icon-white'),
            iniciar_tarea_path(), class: clase,
            disabled: disabled, id: 'iniciar_tarea',
            confirm: '¿Está seguro que desea INICIAR esta tarea?')
  end

  def link_finalizar_tarea(expediente)
    if expediente.tarea_expediente_actual.finalizado?
      clase = 'btn'
      disabled = 'disabled'
    else
      clase = 'btn btn-primary'
    end

    link_to(icon_tag('Finalizar', class: 'icon-ok-sign icon-white'),
            finalizar_tarea_path(),
            class: clase, disabled: disabled,
            id: 'finalizar_tarea',
            confirm: '¿Está seguro que desea FINALIZAR esta tarea?')
  end

  def link_cancelar_tarea(expediente, vista_tarea)
    tarea_expediente_actual = expediente.tarea_expediente_actual
    tarea_actual_finalizado = tarea_expediente_actual.finalizado?
    if tarea_actual_finalizado
      clase = 'btn'
      disabled = 'disabled'
      rel = ''
    else
      clase = 'btn btn-primary'
      rel = "#{expediente.id}-#{vista_tarea.id }-#{ tarea_expediente_actual.id }"
    end

    link_to(icon_tag('Cancelar', :class => 'icon-stop icon-white'),
            cancelar_tarea_path(),
            class: clase, disabled: disabled,
            rel: rel,
            id: 'cancelar_tarea',
            confirm: '¿Está seguro que desea CANCELAR esta tarea?')
  end

  def definir_clase_seguimiento(tarea, tareas_realizadas, tarea_actual)
    clase = ''
    tareas_realizadas.each do |t|
      if tarea.tarea_id == t.tarea_id
        clase = 'realizado'
        if tarea.tarea_id == tarea_actual
          clase = 'actual'
        end
        break
      else
        clase = 'pendiente'
      end
    end
    clase
  end

  def mostrar_fecha_inicio(tarea, tareas_realizadas)
    fecha = ''
    tareas_realizadas.each do |t|
      if tarea.tarea_id == t.tarea_id
        fecha = t.tarea_expediente_fecha_inicio
        break
      else
        fecha = ''
      end
    end
    fecha
  end

  def mostrar_fecha_fin(tarea, tareas_realizadas)
    fecha = ''
    tareas_realizadas.each do |t|
      if tarea.tarea_id == t.tarea_id && t.tarea_expediente_fecha_fin.present?
        fecha = t.tarea_expediente_fecha_fin
        break
      else
        fecha = ''
      end
    end
    fecha
  end

  def mostrar_funcionario(tarea, tareas_realizadas)
    funcionario = ''
    tareas_realizadas.each do |t|
      if tarea.tarea_id == t.tarea_id
        funcionario = t.usuario.funcionario.nombre_completo
        break
      else
        funcionario = ''
      end
    end
    funcionario
  end

  def verificar_documento(adjunto, adjuntos_tareas_expedientes)
    boolean = false
    adjuntos_tareas_expedientes.each do |a|
      if a.adjunto_id == adjunto.id
        boolean = true
        break
      end
    end
    boolean
  end
end
