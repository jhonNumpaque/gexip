#encoding: utf-8

def ente_valido
	@ente ||= {:nombre=>'jose'}
	@ente ||= {:apellido=>'gonzalez'}
	@ente ||= {:tipo_documento_id=>1}
	@ente ||= {:documento=>'1.234.567'}
end

def crear_ente(rol)
	visit '/cargos/new'
	fill_in 'Nombre', :with => rol[:nombre]
	click_button 'Guardar'
end

def iniciar_sesion usuario
  visit '/usuarios/sign_in'
  fill_in "Usuario", :with => usuario[:login]
  fill_in "Contraseña", :with => usuario[:password]
  click_button "Ingresar"
end

Given /^que estoy logueado$/ do
  #iniciar_sesion usuario_valido
end

When /^creo un ente con los datos válidos$/ do
	crear_ente ente_valido
end

Then /^debería ver un mensaje de ente creado$/  do
	page.should have_content 'Ente creado!'
end

When /^creo un ente sin especificar el nombre$/ do
	ente = ente_valido
	ente[:nombre] = nil
	crear_ente ente
end

Then /^debería ver un mensaje de nombre requerido$/  do
	page.should have_content 'Nombreno puede estar en blanco'
end

When /^creo un ente sin especificar el apellido$/ do
	ente = ente_valido
	ente[:apellido] = nil
	crear_ente ente
end

Then /^debería ver un mensaje de apellido requerido$/  do
	page.should have_content 'Apellidono puede estar en blanco'
end

When /^creo un ente sin especificar el tipo documento$/ do
	ente = ente_valido
	ente[:tipo_documento_id] = nil
	crear_ente ente
end

Then /^debería ver un mensaje de tipo documento requerido$/  do
	page.should have_content 'Tipo documentono puede estar en blanco'
end

When /^creo un ente sin especificar el documento$/ do
	ente = ente_valido
	ente[:documento] = nil
	crear_ente ente
end

Then /^debería ver un mensaje de documento requerido$/  do
	page.should have_content 'Documentono puede estar en blanco'
end