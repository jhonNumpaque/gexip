# language: es
Característica: editar cargo
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder editar cargos

	Antecedentes:
		Given que estoy logueado

	Escenario: El administrador edita un cargo con los datos válidos
	                When edito un cargo con los datos válidos
		Then debería ver un mensaje de cargo actualizado

	Escenario: El administrador no especifica el nombre del cargo
	                When edito un cargo sin especificar el nombre
		Then debería ver un mensaje de nombre requerido