module ProcedimientosHelper
	def tipos_tareas(tarea)
		@tipos_mostrar = []
		logico_pendiente = tarea.logicos_pendientes
		actividad = tarea.actividad
		total_tareas = actividad.procedimiento.total_tareas
		@tipos_mostrar << 'inicio' if total_tareas == 0 && actividad.orden == 1
		@tipos_mostrar << 'proceso' if total_tareas > 0 && actividad.orden >= 1
		@tipos_mostrar << 'logica' if total_tareas > 0 && actividad.orden >= 1
		@tipos_mostrar << 'traslado' if total_tareas > 0 && actividad.orden >= 1
		@tipos_mostrar << 'fin' if total_tareas > 1 && logico_pendiente.blank?  && actividad.orden >= 1
		@tipos_mostrar << 'almacenamiento' if total_tareas > 0  && actividad.orden >= 1
		render('/helpers/tipos_tareas')
	end

	def respuestas_logicas(respuestas_logicas_pendientes)
		respuestas_logicas_pendientes.map{ |r| { id: r.id, nombre: r.nombre, tipo: r.tipo_logica.upcase } }.to_json.html_safe
	end

	def mostrar_tipo_tarea(tarea)
		render('/helpers/mostrar_tipo_tarea', tarea: tarea)
	end
end
