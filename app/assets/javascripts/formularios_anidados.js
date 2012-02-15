/*
*    Utilizados para agregar y sacar nuevos elementos
 *  en los formularios anidados
 *
 * nueva versión de agregar/quitar anidados
 */
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("1");
    $(link).parent().hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).before(content.replace(regexp, new_id));
}

