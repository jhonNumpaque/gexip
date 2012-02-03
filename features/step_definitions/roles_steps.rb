#encoding: utf-8

def rol_valido
	@rol ||= {:nombre=>'administrador'}
end

def crear_rol(rol)
	visit '/roles/new'
	fill_in 'Nombre', :with => rol[:nombre]
	click_button 'Guardar'
end

def iniciar_sesion usuario
  visit '/usuarios/sign_in'
  fill_in "Usuario", :with => usuario[:login]
  fill_in "Contraseña", :with => usuario[:password]
  click_button "Ingresar"
end

Dado /^que estoy logueado$/ do
  #iniciar_sesion usuario_valido
end

Cuando /^creo un rol con los datos validos$/ do
	crear_rol rol_valido
end

Entonces /^debería ver un mensaje de rol creado$/  do
	page.should have_content 'Rol creado!'
end

Cuando /^creo un rol sin especificar el nombre$/ do
	rol = rol_valido
	rol[:nombre] = nil
	crear_rol rol
end

Entonces /^debería ver un mensaje de nombre requerido$/  do
	page.should have_content 'Nombreno puede estar en blanco'
end