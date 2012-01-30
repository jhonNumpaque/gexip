# language: es
Característica: crear usuario
	Para permitir el acceso al sistema
	Como administrador
	Quiero poder crear nuevos usuarios

	Antecedentes:
		Dado que estoy autenticado

	Escenario: El administrador crea un usuario con datos válidos
		Cuando creo un usuario con datos válidos
		Entonces debería ver un mensaje de confirmación

	Escenario: El administrador ingresa un email incorrecto
		Cuando creo un usuario con un email incorrecto
		Entonces debería ver un mensaje de email inválido

	Escenario: El administrador no especifica un password
		Cuando creo un usuario sin escribir una contraseña
		Entonces debería ver un mensaje de password requerido

	Escenario: El administrador no especifica una confirmación de password
		Cuando creo un usuario sin escribir una confirmación de contraseña
		Entonces debería ver un mensaje de contraseña requerida

	Escenario: El administrador escribe una contraseña y confirmación de contraseña no coincidentes
		Cuando creo un usuario con una confirmación de contraseña no coincidente
		Entonces debería ver un mensaje de contraseña no coincidente
