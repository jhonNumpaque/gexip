# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expediente do
      proceso_id ""
      procedimiento_id 1
      tarea_actual_id 1
      tarea_anterior_id 1
      ente_id 1
      usuario_id 1
      descripcion "MyString"
      observacion "MyString"
      observacion_fin "MyString"
      estado "MyString"
      usuario_ingreso_id 1
      fecha_ingreso "2012-03-28 19:55:51"
      usuario_finalizo_id 1
      fecha_finalizo "2012-03-28 19:55:51"
      numero 1
      copia false
    end
end