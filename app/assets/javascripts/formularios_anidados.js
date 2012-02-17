/*
*    Utilizados para agregar y sacar nuevos elementos
 *  en los formularios anidados
 *
 * nueva versión de agregar/quitar anidados
 */
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).parent().parent().hide();
    return false;
}

function add_fields(container, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(container).append(content.replace(regexp, new_id));
}

