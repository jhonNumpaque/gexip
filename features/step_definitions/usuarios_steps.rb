# encoding: utf-8

def usuario_valido
  @user ||= { :nombres => "Marcos", :email => "marcos@gmail.com",
    :password => "please", :password_confirmation => "please" }
end

def crear_usuario(usuario)
  visit '/usuarios/new'
  fill_in 'Nombres', :with => usuario[:nombres]
  fill_in 'Email', :with => usuario[:email]
  fill_in 'Contraseña', :with => usuario[:password]
  fill_in 'Confirmación de Contraseña', :with => usuario[:password_confirmation]
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
  usuario = usuario_valido[:email] = 'noesemail'
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de email inválido$/ do
  page.should have_content 'Email inválido'
end

Cuando /^creo un usuario sin escribir una contraseña$/ do
  usuario = usuario_valido[:password] = nil
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de password requerido$/ do
  page.should have_content 'Contraseña no puede quedar vacío'
end

Cuando /^creo un usuario sin escribir una confirmación de contraseña$/ do
  usuario = usuario_valido[:password_confirmation] = nil
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de contraseña requerida$/ do
  page.should have_content 'Confirmación de Contraseña no puede quedar vacío'
end

Cuando /^creo un usuario con una confirmación de contraseña no coincidente$/ do
  usuario = usuario_valido[:password_confirmation] = 'holaad'
  crear_usuario usuario
end

Entonces /^debería ver un mensaje de contraseña no coincidente$/ do
  page.should have_content 'Contraseña no coincide'
end
