# language: es
Característica: crear pais
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos paises

	Antecedentes:
		Dado que estoy logueado

	Escenario: El administrador crea un país con los datos válidos
	                Cuando creo un país con los datos válidos
		Entonces debería ver un mensaje de país creado

	Escenario: El administrador no especifica el nombre del país
	                Cuando creo un país sin especificar el nombre
		Entonces debería ver un mensaje de nombre requerido