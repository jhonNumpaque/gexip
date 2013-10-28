# encoding:utf-8
module ApplicationHelper
  
  # Permite crear un icono para bootstrap con un nombre dado
  # 
  # Ejemplo:
  #  icon_tag('Editar', :class => 'icon-pencil')
  def icon_tag(name, options = {})
    options[:class] ||= 'icon-list-alt'
    content_tag(:i, nil, :class => options[:class]).concat(name)
  end
  
  # Imprime Sí o No dependiendo del valor del parámetro
  # Ejemplo:
  #  si_no(true) #=> Sí
  #  si_no(false) #=> No
  def si_no(valor)
    valor ? 'Sí' : 'No'
  end

  def format_date(date, format="%d/%m/%Y %H:%M")
    format = "%d/%m/%Y" if date.is_a?(Date)
    date.strftime(format)
  end
  
  def fecha_formato_en_a_es(fecha)
    arr = fecha.split('-')
    # arr[0] => mes arr[1] => dia arr[2] => anho
    fecha = arr[1] + "-" + arr[0]  + "-" + arr[2] 
    fecha.to_datetime
  end

  def required_label(label)
    content_tag(:em, "*", class: 'required').concat(" #{label}")
  end

	def menu_link_to(name,controller,options={})
		defaults = {
				action: :index,
		    wrapper_tag: false,
		    link_options: {}
		}
		options = options.reverse_merge(defaults)
		res = link_to(name,url_for(:controller => controller, :action => options[:action]),options[:link_options])
		res = content_tag(options[:wrapper_tag],res) if options[:wrapper_tag]
		res if tiene_permiso?(controller,options[:action])
	end

end
