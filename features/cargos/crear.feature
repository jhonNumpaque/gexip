# language: es
Característica: crear cargo
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos roles

	Antecedentes:
		Dado que estoy logueado

	Escenario: El administrador crea un cargo con los datos válidos
	                Cuando creo un cargo con los datos válidos
		Entonces debería ver un mensaje de cargo creado

	Escenario: El administrador no especifica el nombre del cargo
	                Cuando creo un cargo sin especificar el nombre
		Entonces debería ver un mensaje de nombre requerido