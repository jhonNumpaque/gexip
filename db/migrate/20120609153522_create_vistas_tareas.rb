class CreateVistasTareas < ActiveRecord::Migration
  def up
    sql = 'CREATE OR REPLACE VIEW vistas_tareas AS
             SELECT p.id procedimiento_id,
              p.nombre procedimiento_nombre,
              p.objetivo procedimiento_objetivo,
              p.definiciones procedimiento_definiciones,
              p.elabora_fecha procedimiento_elabora_fecha,
              p.elabora_usuario procedimiento_elabora_usuario,
              p.revisado_fecha procedimiento_revisado_fecha,
              p.revisado_usuario procedimiento_revisado_usuario,
              p.aprobado_fecha procedimiento_aprobado_fecha,
              p.aprobado_usuario procedimiento_aprobado_usuario,
              p.serieproceso_id procedimiento_serieproceso_id,
              p.created_at procedimiento_created_at,

              a.id actividad_id,
              a.descripcion actividad_descripcion,
              a.orden actividad_orden,
              a.created_at actividad_created_at,

              t.id,
              t.id tarea_id,
              t.orden,
              t.nombre,
              t.metodo,
              t.tiempo_ejecucion,
              t.unidad_tiempo_id,
              t.tipo,
              t.cargo_estructura_id,
              t.tarea_sgt_id,
              t.tarea_alt_id,
              t.created_at

            from tareas t join actividades a
              on a.id = t.actividad_id join procedimientos p
              on p.id = a.procedimiento_id
            order by p.id, a.orden, t.orden;'
    execute(sql)
  end

  def down
    sql = 'DROP VIEW vistas_tareas;'
    execute(sql)
  end
end
