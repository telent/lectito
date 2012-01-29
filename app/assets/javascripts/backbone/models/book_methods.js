(function() {
    this.reshelve=function(shelf) {
	var url=this.url()+"/reshelve.json";
	var book=this;
	jQuery.ajax(url,{
	    data: {shelf_id: shelf.get('id')},
	    dataType: 'json',
	    type: 'POST',
	    error: function(xhr,s,e) { console.log("failed ",s,e); },
	    success: function (r,s) {
		book.fetch(); 
	    },
	});
    }
}).call(Lectito.Models.Book.prototype)