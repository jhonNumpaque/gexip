Gexip::Application.routes.draw do

  # tree procedimientos y cia
  match 'obtener/arbol' => 'procedimientos#jstree', :as => :procedimientos_jstree
  match 'procedimientos/ni' => 'procedimientos#new_index', :as => :new_procedimientos_index
  
  resources :organismos_internos

  resources :personas_juridicas

  resources :personas_fisicas

  resources :funcionarios

  resources :estructuras

  resources :expedientes
  
  resources :unidades_tiempos
  resources :tareas

  resources :subprocesos
  match 'subprocesos/imprimir/reporte_formato_39' => 'subprocesos#reporte_formato_39', :as => :reporte_formato_39

  resources :procesos
  match 'procesos/imprimir/reporte_formato_38' => 'procesos#reporte_formato_38', :as => :reporte_formato_38
    
  resources :macroprocesos
  match 'macroprocesos/imprimir/reporte_formato_37/' => 'macroprocesos#reporte_formato_37', :as => :reporte_formato_37

  resources :procedimientos

  match 'denegado' => 'usuarios#denegado', :as => 'denegado'
  
  resources :barrios

  resources :paises

  resources :ciudades

  resources :tipos_documentos

  resources :cargos

  resources :entes

  resources :roles
  
  resources :informes

  resources :tiempos_demorados
  match 'tiempos_demorados/reporte/listar/' => 'tiempos_demorados#listar', :as => :listar
  
  devise_for :usuarios, :controllers => { :registrations => "usuarios", :sessions => 'sesiones' } do 
    get "/login" => "sesiones#new"
    get "/logout" => "sesiones#destroy"
  end

#usuarios
  resources :usuarios
	match '/usuarios/datos/cambiar_clave/' => 'usuarios#cambiar_clave', :as => :cambiar_clave
  match '/usuarios/datos/modificar_datos/:id' => 'usuarios#modificar_datos', :as => :modificar_datos
  match '/usuarios/datos/cambiar_clave_grabar/' => 'usuarios#cambiar_clave_grabar', :as => :cambiar_clave_grabar
  match '/usuarios/datos/modificar_datos_grabar/:id' => 'usuarios#modificar_datos_grabar', :as => :modificar_datos_grabar
  
  match '/:actividad_id/agregar_tarea' => 'actividades#agregar_tarea', :as => 'agregar_tarea'
  match '/:actividad_id/listar_tareas' => 'actividades#listar_tareas', :as => 'listar_tareas'
  match '/editar_tarea' => 'tareas#edit', :as => 'editar_tarea'
  match 'iniciar_tarea' => 'tareas#iniciar_tarea', :as => 'iniciar_tarea'
  match 'finalizar_tarea' => 'tareas#finalizar_tarea', :as => 'finalizar_tarea'
  match 'cancelar_tarea' => 'tareas#cancelar_tarea', :as => 'cancelar_tarea'
  match 'iniciar_tarea_logica' => 'tareas#iniciar_tarea_logica', :as => 'iniciar_tarea_logica'
  #cargos
  match 'agregar_cargo' => 'cargos#agregar_cargo', :as => 'agregar_cargo'
  
  # file upload
  resources :uploads

  #informes
  match 'mostrar_formulario/:tipo_informe' => 'informes#mostrar_formulario', :as => :mostrar_formulario
  
  #entes
  match '/search' => 'entes#search', :as => 'search_ente'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'expedientes#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
