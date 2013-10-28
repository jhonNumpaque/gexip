class VistaExpedienteTotal < ActiveRecord::Base
  set_table_name 'vistas_expedientes_totales'

  #constantes
  MESES = {'01' => 'Enero', '02' =>'Febrero', '03' => 'Marzo', '04' => 'Abril', '05' => 'Mayo', '06' => 'Junio', '07' => 'Julio', '08' => 'Agosto', '09' => 'Septiembre', '10' => 'Octubre', '11' => 'Noviembre', '12' => 'Diciembre'}
  SEMESTRES = {'01' => 'Primer Semestre', '02' => 'Segundo Semestre'}
  CUATRIMESTRES = {'01' => 'Primer Cuatrimestre', '02' => 'Segundo Cuatrimestre', '03' => 'Tercer Cuatrimestre'}
  TRIMESTRES = {'01' => 'Primer Trimestre', '02' => 'Segundo Trimestre', '03' => 'Tercer Trimestre', '04' => 'Cuarto Trimestre'}

end