$(function(){
  $('.tab a').click(function(){
    $('.tab').attr('class', 'tab');
    switch ($(this).attr('class')) {
      case 'pf':
        $('#expediente_ente_id').parent().parent().find('label').html('* Cédula/Nombre y Apellido');
        break;
      case 'pji':
        $('#expediente_ente_id').parent().parent().find('label').html('* Código/Nombre');
        break;
      case 'pje':
        $('#expediente_ente_id').parent().parent().find('label').html('* Código/Nombre');
        break;
    }
    $(this).parent().attr('class', 'tab active');
    return false;
  });
});