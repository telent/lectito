$(document).ready(function() {    
    $('span.actions_dropdown').click(function() {
	var was=$(this).hasClass('open');
	$('span.actions_dropdown').removeClass('open');
	if(!was) $(this).addClass('open');
    });
    $('span.actions_dropdown li').click(function(e,nested) {
	// clicking anywhere in the LI should have same effect as 
	// directly on the A.

	// if the A element is subject to rails UJS (e.g. to change the 
	// method from GET to POST) this is implemented by adding handlers
	// for the click.rails to it, so we cannot simply visit its href
	// attribute, we have to simulate the click

	// we don't want that click to invoke this handler recursively 
	// though, even though the A is contained withing this element
	if(!nested) {
	    $('a',this).trigger('click',[true]);
	}
    });
})
