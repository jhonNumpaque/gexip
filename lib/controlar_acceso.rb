module ControlarAcceso
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def controlar_acceso!
      return true if ignorar?
      
      redirect_to denegado_path unless tiene_permiso?      
    end
    
    def permisos
      #@permisos ||= current_usuario.rol.permisos
    end
    
    def ignorar?
      lista_ignorar.include?("#{controller_name}.#{action_name}")
    end
    
    def lista_ignorar
      ['sesiones.new', 'sesiones.create', 'sesiones.destroy', 'usuarios.denegado']       
    end
    
    def tiene_permiso?
      permiso = current_usuario.rol.permisos.find_by_controlador_and_accion(controller_name, action_name)
      unless permiso 
        permiso = Permiso.find_by_controlador_and_accion(controller_name, action_name)
        return true if permiso.publico
        
        permiso = nil unless permiso.secundario? && permiso.accion_principal.roles_permisos.find_by_rol_id(current_usuario.rol_id)          
      end
      permiso.present?
    end
    
  end
end