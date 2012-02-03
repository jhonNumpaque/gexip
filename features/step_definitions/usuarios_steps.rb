# encoding: utf-8

def usuario_valido
  @user ||= { :nombres => "Marcos", :login => 'marcos', :email => "marcos@gmail.com",
    :password => "please", :password_confirmation => "please", :apellidos => 'Gadea', :documento => 3322323 }
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
  fill_in "Usuario", :with => usuario[:login]
  fill_in "Contraseña", :with => usuario[:password]
  click_button "Ingresar"
end

Dado /^que estoy autenticado$/ do
  #iniciar_sesion usuario_valido
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
  page.should have_content 'Email es inválido'
end

Cuando /^creo un usuario sin escribir una contraseña$/ do
  usuario = usuario_valido
  usuario[:password] = nil
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de password requerido$/ do
  page.should have_content 'Password no puede estar en blanco'
end

Cuando /^creo un usuario sin escribir una confirmación de contraseña$/ do
  usuario = usuario_valido
  usuario[:password_confirmation] = nil
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de contraseña requerida$/ do
  page.should have_content 'Password no coincide con la confirmación'
end

Cuando /^creo un usuario con una confirmación de contraseña no coincidente$/ do
  usuario = usuario_valido
  usuario[:password_confirmation] = 'holaad'
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de contraseña no coincidente$/ do
  page.should have_content 'Password no coincide con la confirmación'
end
