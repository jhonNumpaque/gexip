# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :persona_juridica do
      nombre "MyString"
      apellido "MyString"
      documento "MyString"
      direccion "MyString"
      telefono "MyString"
      territorio_id ""
      cargo_id ""
    end
end