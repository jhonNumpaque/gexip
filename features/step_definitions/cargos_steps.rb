#encoding: utf-8

def cargo_valido
	@rol ||= {:nombre=>'recepcionista'}
end

def crear_cargo(rol)
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

When /^creo un cargo con los datos válidos$/ do
	crear_cargo cargo_valido
end

Then /^debería ver un mensaje de cargo creado$/  do
	page.should have_content 'Cargo creado!'
end

When /^creo un cargo sin especificar el nombre$/ do
	cargo = cargo_valido
	cargo[:nombre] = nil
	crear_cargo cargo
end

Then /^debería ver un mensaje de nombre requerido$/  do
	page.should have_content 'Nombreno puede estar en blanco'
end