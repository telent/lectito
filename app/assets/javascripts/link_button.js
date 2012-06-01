$(document).ready(function() {
    $('button.link').click(function(e) {
	document.location=$(this).data('href');
	return false;
    })
});
    
