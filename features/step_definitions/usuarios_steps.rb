# encoding: utf-8


def usuario_valido
  @usuario ||= { :nombres => "Marcos", :login => 'marquitos', :email => "marcos@gmail.com",
    :password => "dalenplease", :password_confirmation => "dalenplease", :apellidos => 'Gadea', :documento => 3322323, :rol_id => 1 }
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

def iniciar_sesion usuario
  visit '/usuarios/sign_in'
  fill_in "Nombre de usuario", :with => usuario[:login]
  fill_in "Contraseña", :with => usuario[:password]
  click_button "Iniciar"
end

Dado /^que estoy autenticado$/ do
  usuario = Usuario.new usuario_valido
  #iniciar_sesion usuario_valido  
  visit '/usuarios/sign_in'
  fill_in "Nombre de usuario", :with => usuario.login
  fill_in "Contraseña", :with => usuario_valido[:password]
  click_button 'Iniciar'
  page.should have_content 'Ingreso de sesión exitosamente.'
  usuario.destroy
end

Cuando /^creo un usuario con datos válidos$/ do
 crear_usuario usuario_valido
end

Entonces /^debería ver un mensaje de confirmación$/ do
  page.should have_content 'Usuario creado!'
end

Cuando /^creo un usuario con un email incorrecto$/ do
  usuario = usuario_valido
  usuario[:email] = 'noesemail'
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de email inválido$/ do
  page.should have_content 'Emailes inválido'
end

Cuando /^creo un usuario sin escribir una contraseña$/ do
  usuario = usuario_valido
  usuario[:password] = nil
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de password requerido$/ do
  page.should have_content 'Contraseñano puede estar en blanco'
end

Cuando /^creo un usuario sin escribir una confirmación de contraseña$/ do
  usuario = usuario_valido
  usuario[:password_confirmation] = nil
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de contraseña requerida$/ do
  page.should have_content 'Contraseñano coincide con la confirmación'
end

Cuando /^creo un usuario con una confirmación de contraseña no coincidente$/ do
  usuario = usuario_valido
  usuario[:password_confirmation] = 'holaad'
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de contraseña no coincidente$/ do
  page.should have_content 'Contraseñano coincide con la confirmación'
end
