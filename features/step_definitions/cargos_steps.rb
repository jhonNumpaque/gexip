#encoding: utf-8

def cargo_valido
	@cargol ||= {:nombre=>'recepcionista'}
end

def crear_cargo(cargo)
	visit '/cargos/new'
	fill_in 'Nombre', :with => cargo[:nombre]
	click_button 'Guardar'
end

def editar_cargo(cargo)
	visit '/cargos/edit'
	fill_in 'Nombre', :with => cargo[:nombre]
	click_button 'Guardar'
end

def eliminar_cargo(cargo)
	cargo.destroy
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

When /^edito un cargo con los datos válidos$/ do
	editar_cargo cargo_valido
end

Then /^debería ver un mensaje de cargo actualizado$/  do
	page.should have_content 'Cargo actualizado'
end

When /^edito un cargo sin especificar el nombre$/ do
	cargo = cargo_valido
	cargo[:nombre] = nil
	editar_cargo cargo
end

Then /^debería ver un mensaje de nombre requerido$/  do
	page.should have_content 'Nombreno puede estar en blanco'
end

#When /^doy click al boton eliminar$/ do
#	cargo = cargo_valido
#end
#
#And /^confirmo accion$/ do
#	eliminar_cargo cargo_valido
#end
#
#Then /^debería ver un mensaje de cargo eliminado$/  do
#	page.should have_content 'Cargo eliminado'
#end