# language: es
Característica: crear ente
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos entes

	Antecedentes:
		Given que estoy logueado

	Escenario: El administrador crea un ente con los datos válidos
	                When creo un ente con los datos válidos
		Then debería ver un mensaje de cargo creado

	Escenario: El administrador no especifica el nombre del ente
	                When creo un ente sin especificar el nombre
		Then debería ver un mensaje de nombre requerido

	Escenario: El administrador no especifica el apellido del ente
	                When creo un ente sin especificar el apellido
		Then debería ver un mensaje de apellido requerido

	Escenario: El administrador no especifica el tipo documento del ente
	                When creo un ente sin especificar el tipo documento
		Then debería ver un mensaje de tipo documento requerido

	Escenario: El administrador no especifica el documento del ente
	                When creo un ente sin especificar el documento
		Then debería ver un mensaje de documento requerido

	