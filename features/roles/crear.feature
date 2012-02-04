# language: es
Característica: crear rol
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos roles

	Antecedentes:
	    Dado que estoy logueado

	Escenario: El administrador crea un rol con los datos válidos
	                Cuando creo un rol con los datos válidos
		Entonces debería ver un mensaje de rol creado

	Escenario: El administrador no especifica el nombre del rol
	                Cuando creo un rol sin especificar el nombre
		Entonces debería ver un mensaje de nombre requerido
	
