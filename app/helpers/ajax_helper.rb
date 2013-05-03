module AjaxHelper
  # == Descripcion
  # Crea un componente *JQuery* para hacer un live query
  # == Parametros
  # *hidden_id*:: nombre del elemento hidden que guardara el valor seleccionado
  # *input*:: html del objeto input que se utilizara como input de datos
  # *url*:: Url que realizará la busqueda y devolvera el *JSON* necesario
  # *extra*:: Nombre del parametro extra a utilizar
  # *extra_jquery*:: Instruccion javascript a utilizar para leer el parametro *extra* a utilizar
  # *value*:: Valor inicial para el componente(en caso de hacer una edición)
  # *minimo* :: Cantidad de caracteres para empezar el filtrado
  # *clase*:: La Clase que se va a utilizar para la busqueda
  # *descripcion*:: El atributo que se va a filtrar
  #
  # == Ejemplo de uso
  #  autocomplete "cliente", :hidden_id => "venta_cliente_id",
  #                            :input => f.hidden_field(:cliente_id),
  #                            :url => "/clientes/buscar_cliente",
  #                            :extra => :dependencia_id, :extra_jquery => "$('#buscar_dependencia')",
  #                            :value => (@venta.cliente_id.nil? ? nil : @venta.cliente.nombre) %>

  def autocomplete(nombre, args)
    extra = args[:extra] ? true : false
    args[:input] ||= '<input type="hidden" name="cliente_id" id="cliente_id">'
    args[:url] ||= ""
    args[:hidden_id] ||= "cliente_id"
    args[:extra] ||= ""
    args[:value] ||= ""
    args[:extra_jquery] ||= args[:extra]
    args[:minimo] ||= "3"
    args[:descripcion] ||="descripcion"

    render :partial => "helpers/buscar",
      :locals => {
      :nombre => nombre,
      :input => args[:input],
      :hidden_id => args[:hidden_id],
      :url => args[:url],
      :extra => args[:extra],
      :have_extras => extra,
      :extra_jquery => args[:extra_jquery],
      :value => args[:value],
      :minimo=> args[:minimo],
      :clase=> args[:clase],
      :descripcion=> args[:descripcion]

    }
  end

  # == Descripción
  # Crea un combo que estará realacionado a otro *input*, utilizando la libreria *JQuery*, al cambiar el valor
  # *input* automaticamente se refrescará el contenido del combo.
  # == Parametros
  # *display*:: atributo que se utilizará como Etiqueta a mostrar
  # *value*:: atributo que se utilizará como clave
  # *url*:: Url que realizará la busqueda y devolvera el *JSON* necesario
  # *linked*:: Nombre input asociado al combobox
  # *param*:: Como se llamará el parametro que se enviara al URL para realizar la busqueda
  # *clase*:: La Clase que se va a utilizar para la busqueda
  #
  # == Ejemplo de uso
  #  linked_combo "dependencia_dependencia_id", :linked => "edificio_edificio_id",
  #      :url => "/dependencias.json", :param => "edificio_id", :clase => "dependencia", :value => "descripcion"
  def linked_combo(nombre, args)
    args[:url] ||= ""
    args[:display] ||= "nombre"
    args[:value] ||= "id"
    args[:extra] ||= ""
    args[:clase] ||= ""
    args[:extra_code] ||= ""
    args[:extra_jquery] ||= args[:extra]
    args[:extra_code] ||= args[:extra_code]

    render :partial => "helpers/combo", :locals => {
      :nombre => nombre,
      :display => args[:display],
      :value => args[:value],
      :url => args[:url],
      :extra => args[:extra],
      :extra_jquery => args[:extra_jquery],
      :extra_code => args[:extra_code],
      :linked => args[:linked],
      :param => args[:param],
      :clase=> args[:clase]

    }
  end
  
  # Permite utilizar el will_paginate con ajax
  # == AUTOR
  # * <tt>Rafael Franco</tt>
  # * 14-08-2009
  # * Extraido de: <tt>http://weblog.redlinesoftware.com/2008/1/30/willpaginate-and-remote-links</tt>
  #
  # == PARAMETROS
  # *collection*:: La colecion de datos ha ser paginado
  # *with*:: (opcional) Lista de parametros a ser enviados con el request
  # *update*:: (opcional) Div a ser actualizado con el resultado del request.
  #
  # == MODO DE USO
  #  <%= will_paginate_ajax @personas %> # simple
  #  <%= will_paginate_ajax @personas, :with => "'parametro='+$('#algo').val()" %> # con parametros
  #  <%= will_paginate_ajax @personas, :with => "'parametro='+$('#algo').val()", :update => 'algun_div' %> # con params y actualizando div
  #
  # == REQUERIMIENTOS
  # <tt>app/helpers/remote_link_renderer.rb</tt>
  def will_paginate_ajax(collection, options = {})
    options[:param_name] ||= "page"
    options[:params] ||= {}
    will_paginate collection, :renderer => 'RemoteLinkRenderer' , :params => options[:params], 
      :param_name => options[:param_name],
      :remote => {:with => options[:with], :update => options[:update]}
  end
end