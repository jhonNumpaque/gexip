# language: es
Característica: crear cargo
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos cargos

	Antecedentes:
		Given que estoy logueado

	Escenario: El administrador crea un cargo con los datos válidos
	                When creo un cargo con los datos válidos
		Then debería ver un mensaje de cargo creado

	Escenario: El administrador no especifica el nombre del cargo
	                When creo un cargo sin especificar el nombre
		Then debería ver un mensaje de nombre requerido