# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :procedimiento do
      nombre "MyString"
      objetivo "MyString"
      definiciones "MyString"
      elabora_fecha "2012-02-15"
      elabora_usuario 1
      revisado_fecha "2012-02-15"
      revisado_usuario 1
      aprobado_fecha "2012-02-15"
      aprobado_usuario 1
    end
end