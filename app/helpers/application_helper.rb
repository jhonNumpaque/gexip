module ApplicationHelper
  
  # Permite crear un icono para bootstrap con un nombre dado
  # 
  # Ejemplo:
  #  icon_tag('Editar', :class => 'icon-pencil')
  def icon_tag(name, options = {})
    options[:class] ||= 'icon-list-alt'
    content_tag(:i, nil, :class => options[:class]).concat(name)
  end
end
