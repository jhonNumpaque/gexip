# encoding: utf-8

Dado /^que estoy autenticado$/ do
  pending # express the regexp above with the code you wish you had
end

Cuando /^creo un usuario con datos válidos$/ do
 usuario = FactoryGirl.build(:usuario_jose)
 usuario.save.should == true
end

Entonces /^debería ver un mensaje de confirmación$/ do
  pending # express the regexp above with the code you wish you had
end

Cuando /^creo un usuario con un email incorrecto$/ do
  pending # express the regexp above with the code you wish you had
end

Entonces /^debería ver un mensaje de email inválido$/ do
  pending # express the regexp above with the code you wish you had
end

Cuando /^creo un usuario sin escribir una contraseña$/ do
  pending # express the regexp above with the code you wish you had
end

Entonces /^debería ver un mensaje de password requerido$/ do
  pending # express the regexp above with the code you wish you had
end

Cuando /^creo un usuario sin escribir una confirmación de contraseña$/ do
  pending # express the regexp above with the code you wish you had
end

Entonces /^debería ver un mensaje de contraseña requerida$/ do
  pending # express the regexp above with the code you wish you had
end

Cuando /^creo un usuario con una confirmación de contraseña no coincidente$/ do
  pending # express the regexp above with the code you wish you had
end

Entonces /^debería ver un mensaje de contraseña no coincidente$/ do
  pending # express the regexp above with the code you wish you had
end
