# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tarea do
      orden 1
      nombre "MyString"
      metodo "MyString"
      tiempo_ejecucion 1
      unidad_tiempo 1
      tipo "MyString"
      cargo_id 1
      tarea_sgt_id 1
      tarea_alt_id 1
    end
end