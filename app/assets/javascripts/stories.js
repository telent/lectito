
$(document).ready(function() {
	if($('body').data('controller')=='stories') {
	    $('.story').click(function(e) {
		    var u=$(this).data('url');
		    u && (document.location=u);
		});
	}
    });
