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
  
  $('#iniciar_tarea').click(function(){
     $(this).attr('disabled', 'disabled').removeClass('btn-primary');
     var url = $(this).attr('href'); 
     var ids = $('.alert-info').attr('rel').split('-');
     var eid = ids[0];
     var tid = ids[1];
     
     $.get(url, {eid: eid, tid: tid}, null, 'script');
     
     
     $('.alert-info').removeClass('alert-info').addClass('alert-success');
     $('#cancelar_tarea').removeAttr('disabled').addClass('btn-primary');
     $('#finalizar_tarea').removeAttr('disabled').addClass('btn-primary');
     
     return false;
  });
});