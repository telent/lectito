$(document).ready(function() {    
    $('span.actions_dropdown').click(function() {
	var was=$(this).hasClass('open');
	$('span.actions_dropdown').removeClass('open');
	if(!was) $(this).addClass('open');
    });
    $('span.actions_dropdown li').click(function() {
	var url=$('a',this)[0].href;
	document.location=url;
	return false;
    });
})
