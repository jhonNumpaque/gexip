# language: es
Característica: crear rol
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos roles

	Antecedentes:
		Given que estoy autenticado

	Escenario: El administrador crea un rol con los datos válidos
	                When creo un rol con los datos válidos
		Then debería ver un mensaje de rol creado

	Escenario: El administrador no especifica el nombre del rol
	                When creo un rol sin especificar el nombre
		Then debería ver un mensaje de nombre requerido
	
