# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ente do
      nombre "MyString"
      apellido "MyString"
      documento "MyString"
      tipo_documento "MyString"
      direccion "MyString"
      telefono "MyString"
      territorio_id 1
    end
end