# encoding: utf-8

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usuario_jose do
      nombres "José Manuel"
      apellidos "González Ricart"
      documento "3323422"
      ente_id 1
      rol_id 1
      email 'progresivjose@gmail.com'
      login 'jgonzalez'
      password 'jose123'
      password_confirmation 'jose123'
  end
  
  factory :usuario_rafael do
      nombres "Rafael"
      apellidos "Franco"
      documento "4157783"
      ente_id 1
      rol_id 1
      email 'rafael'
      login 'rfranco'
      password 'rafa123'
      password_confirmation 'rafa123'
  end
end
