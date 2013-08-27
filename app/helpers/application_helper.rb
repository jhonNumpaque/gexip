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

  def required_label(label)
    content_tag(:em, "*", class: 'required').concat(" #{label}")
  end

end
