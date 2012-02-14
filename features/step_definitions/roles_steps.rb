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

def crear_usuario(usuario)
  visit '/usuarios/new'
  fill_in 'Nombres', :with => usuario[:nombres]
  fill_in 'Apellidos', :with => usuario[:apellidos]
  fill_in 'Documento', :with => usuario[:documento]
  fill_in 'Email', :with => usuario[:email]
  fill_in 'Contraseña', :with => usuario[:password]
  fill_in 'Usuario', :with => usuario[:login]
  fill_in 'Confirmar Contraseña', :with => usuario[:password_confirmation]
  click_button 'Guardar'
end

def usuario_valido
  @user ||= { :nombres => "Marcos", :login => 'marcos', :email => "marcos@gmail.com",
    :password => "please", :password_confirmation => "please", :apellidos => 'Gadea', :documento => 3322323 }
end

Given /^que estoy autenticado$/ do
	crear_usuario usuario_valido
    iniciar_sesion usuario_valido
end

When /^creo un rol con los datos válidos$/ do
	crear_rol rol_valido
end

Then /^debería ver un mensaje de rol creado$/  do
	page.should have_content 'Rol creado!'
end

When /^creo un rol sin especificar el nombre$/ do
	rol = rol_valido
	rol[:nombre] = nil
	crear_rol rol
end

Then /^debería ver un mensaje de nombre requerido$/  do
	page.should have_content 'Nombreno puede estar en blanco'
end