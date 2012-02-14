# language: es
Característica: destruir cargo
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder destruir cargos

	Antecedentes:
		Given que estoy logueado

	Escenario: El administrador elimina un cargo
	                When doy click al boton eliminar
		and confirmo la accion
		Then debería ver un mensaje de cargo eliminado

	Escenario: El administrador elimina un cargo asociado a un ente
	                When doy click al boton eliminar
		and confirmo la accion
		Then debería ver un mensaje de no puede eliminar el cargo