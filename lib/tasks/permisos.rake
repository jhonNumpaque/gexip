# encoding: utf-8

namespace :permisos do
  desc "Cargar permisos a la base de datos (acciones, controles, "
  task :cargar => :environment do |t|
    
    puts "=== Iniciando carga de permisos ==="
  
    COMB_KEY = :combinados
    ABM_KEY = :abm
    PUB_KEY = :publico
  
    # nombre del método que define las reglas
    ACCION_PERMISOS = 'reglas_permisos'
  
    # los valores por defecto de las reglas
    defaults = { 
      :combinados => { 
        'new' => { :etiqueta => 'Agregar Registro', :acciones => ['create'] }, 
        'edit' => { :etiqueta => 'Editar Registro', :acciones => ['update'] }
      },
      :abm => {
        'destroy' => { :etiqueta => 'Eliminar Registro' }, 
        'show' => { :etiqueta => 'Ver Registro' }, 
        'index' => { :etiqueta => 'Listar Registros' }
      }
    }
  
    controllers = Dir.new("#{Rails.root}/app/controllers").entries  
    ant = ''
  
    controllers.each do |controller|    
      if controller =~ /_controller/ 
        controller_class = controller.camelize.gsub('.rb', '').constantize
      
        globales = {}
        acciones_dependientes = []
        publico = false
        nombre_controlador = controller_class.controller_path
        
        puts "\n---- Controlador: #{nombre_controlador} ----\n"
      
      
        reglas = controller_class.new.send(ACCION_PERMISOS) if controller_class.new.respond_to? ACCION_PERMISOS      
        globales_default = extraer_reglas_globales(defaults)      
        globales = extraer_reglas_globales(reglas) if reglas      
        globales_default.each { |k,v| globales[k] ||= v }      
      
        controller_class.new.action_methods.each do |action|
          
          ya_existe = Permiso.find_by_controlador_and_accion(nombre_controlador, action)
          puts "   X La acción '#{action}' ya existe, omitiendo..." if ya_existe
          if (!ya_existe && action != ACCION_PERMISOS && nombre_controlador != 'application')            
            if globales.has_key? action
            
              accion_padre = false
              etiqueta = globales[action][:etiqueta]            
              publico = globales[action][:key] == PUB_KEY
            
              permiso = Permiso.new(
                :controlador => nombre_controlador, 
                :accion => action, 
                :publico => publico,
                :descripcion => etiqueta
              )            
            
              if globales[action][:key] == COMB_KEY && globales[action][:acciones].present?              
                accion_padre = true
                acciones_dependientes.concat(globales[action][:acciones])
              end
            end
          
            if accion_padre
              puts "  -> Creando '#{action}' (#{etiqueta}) (combinado, principal)..."
              if permiso.save
            
                globales[action][:acciones].each do |acc|
                  accion_actual = Permiso.find_by_controlador_and_accion(permiso.controlador, acc)
                
                  if accion_actual
                    accion_actual.update_attribute(:permiso_id, permiso.id)
                  else
                    puts "    -> Creando '#{acc}' (#{etiqueta}) (combinado, secundario)..."
                    Permiso.create(
                      :controlador => nombre_controlador, 
                      :accion => acc, 
                      :publico => publico,
                      :descripcion => etiqueta,
                      :permiso_id => permiso.id
                    )
                  end                
                end
              end
            elsif !acciones_dependientes.include? action
              etiqueta ||= action.humanize
            
              puts "  -> Creando '#{action}' (#{etiqueta}) (simple)..."
              Permiso.create(
                :controlador => nombre_controlador, 
                :accion => action, 
                :publico => publico,
                :descripcion => etiqueta
              ) 
            end          
          end
        end      
      end
    end 
  end

  def extraer_reglas_globales(reglas)
    globales = {}
  
    reglas.each do |k,v|          
      v.each do |xk, xv|
        globales[xk] = xv.merge({ :key => k })
      end
    end
    globales
  end

  desc "Limpia la tabla de permisos"
  task :limpiar => :environment do |t|
    Permiso.delete_all
    puts "Tabla Permisos limpiada"
  end
end

  