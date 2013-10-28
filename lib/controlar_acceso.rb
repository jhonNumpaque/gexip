module ControlarAcceso
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
		klass.helper_method :tiene_permiso?
		klass.helper_method :al_menos_uno?
  end
  
  module InstanceMethods
    def controlar_acceso!
      if current_usuario.present?
        return true if ignorar?      
        redirect_to denegado_path unless tiene_permiso?      
      end
    end
    
    def permisos
      @permisos ||= current_usuario.rol.permisos
    end
    
    def ignorar?
      lista_ignorar.include?("#{controller_name}.#{action_name}")
    end
    
    def lista_ignorar
      ['sesiones.new', 'sesiones.create', 'sesiones.destroy', 'usuarios.denegado']       
    end
    
    def tiene_permiso?(controller=controller_name,action=action_name)
      permiso = current_usuario.rol.permisos.find_by_controlador_and_accion(controller, action)
      unless permiso 
        permiso = Permiso.find_by_controlador_and_accion(controller, action)
        return true if permiso.publico
        
        permiso = nil unless permiso.secundario? && permiso.accion_principal.roles_permisos.find_by_rol_id(current_usuario.rol_id)          
      end
      permiso.present?
    end

		def al_menos_uno?(rutas)
			tiene = false
			rutas.each do |ruta|
				controller,action = ruta.split('.')
				tiene = tiene_permiso?(controller,action)
				break if tiene
			end
			tiene
		end
  end
end