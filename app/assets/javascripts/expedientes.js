function buscar_ente(type,documento) {
	$.get('/entes/buscar', { type: type, documento: documento }, null, 'script');
}
var tab='pf';
$(function(){
	$('#expediente_numero_documento').change(function(){
		buscar_ente(tab,$(this).val());
	});

    $('.tab a').click(function(){
        $('.tab').attr('class', 'tab');
        switch ($(this).attr('class')) {
            case 'pf':
				tab = 'pf';
                $('#ente_label').html('* Cédula/Nombre y Apellido');
				$('.cajaexp').css('background-color','#F5FFC0');
                break;
            case 'pji':
				tab = 'pji';
                $('#ente_label').html('* Código/Nombre');
				$('.cajaexp').css('background-color','#F3E6DA');
                break;
			case 'pje':
				tab = 'pje';
                $('#ente_label').html('* Código/Nombre');
				$('.cajaexp').css('background-color','#DAE8F3');
                break;
        }
        $(this).parent().attr('class', 'tab active');
        return false;
    });

    $('#iniciar_tarea').click(function(){
        var url = $(this).attr('href'); 
        var ids = $('.alert-info').attr('rel').split('-');
        var eid = ids[0]; // expediente id
        var tid = ids[1]; // tarea id        
        var confirm_message = $(this).attr('data-confirm');
     
        if (confirm(confirm_message)) {
            $.get(url, {
                eid: eid, 
                tid: tid
            }, null, 'script');
        
            $(this).attr('disabled', 'disabled').removeClass('btn-primary');
            $('.alert-info').removeClass('alert-info').addClass('alert-success');
            $('#cancelar_tarea').removeAttr('disabled').addClass('btn-primary');
            $('#finalizar_tarea').removeAttr('disabled').addClass('btn-primary');
        }
     
        return false;
    });
  
    $('#finalizar_tarea').click(function(){     
        var url = $(this).attr('href'); 
        var ids = $('.alert-success').attr('rel').split('-');
        var eid = ids[0];
        var tid = ids[2];
        var confirm_message = $(this).attr('data-confirm');
     
        if (confirm(confirm_message)) {
            $(this).attr('disabled', 'disabled').removeClass('btn-primary');
            $('#cancelar_tarea').attr('disabled', 'disabled').removeClass('btn-primary');
        
            $.get(url, {
                eid: eid, 
                tid: tid
            }, null, 'script');     
            $('#iniciar_tarea').removeAttr('disabled').addClass('btn-primary');     
        }
     
        return false;
    });
  
    $('#cancelar_tarea').click(function(){     
        var url = $(this).attr('href'); 
        var ids = $(this).attr('rel').split('-');
       
        // si se presiona cancelar y no hay tarea ejecutandose
        if (ids.length == 0)
            return false;
       
        var eid = ids[0];
        var teid = ids[2];
        var confirm_message = $(this).attr('data-confirm');
     
        if (confirm(confirm_message)) {
            $(this).attr('disabled', 'disabled').removeClass('btn-primary');
            $('#finalizar_tarea').attr('disabled', 'disabled').removeClass('btn-primary');
        
            $.get(url, {
                eid: eid, 
                teid: teid
            }, null, 'script');     
            $('#iniciar_tarea').removeAttr('disabled').addClass('btn-primary');     
        }
     
        return false;
    });
    
    $('.btn-confirmar').live('click', function(){
        var ids = $(this).attr('rel').split('-');
        var eid = ids[0];
        var tid = ids[1];
        var confirm_message = $(this).attr('data-confirma');
        var tipo_confirm = $(this).attr('id');
        var url = $(this).attr('data-url'); 
        
        if (confirm(confirm_message)) {
            $.get(url, {
                eid: eid, 
                tid: tid,
                tc: tipo_confirm
            }, null, 'script');         
        }
        return false;
    });
});
