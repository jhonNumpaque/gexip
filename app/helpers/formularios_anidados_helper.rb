module FormulariosAnidadosHelper
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)") 
  end

  def link_to_add_fields(name, f, association, options = {})
    options[:partial] ||= "campos_" + association.to_s.singularize
    options[:container] ||= "cont_" + association.to_s.singularize
    options[:locals] = options[:locals].is_a?(Hash) ? options[:locals].merge({ :dinamico => true }) : { :dinamico => true }

    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(:partial => options[:partial], :locals => options[:locals].merge({ :f => builder }))
    end
    link_to_function(name, h("add_fields('##{options[:container]}', \"#{association}\", \"#{escape_javascript(fields)}\")".html_safe),  :id => "add_#{association}")
  end
end
