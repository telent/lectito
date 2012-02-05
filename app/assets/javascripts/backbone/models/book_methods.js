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
    };
    var async_get=function(coll,field) {
	var id=this.get(field+"_id");
	if(id) {
	    var m= coll.fetchId(id);
	    return (m.has("created_at")) ? m : undefined
	} else {
	    return null;
	}
    };
   this.current_shelf=function() { 
	return async_get.call(this,Store.shelves,"current_shelf") 
    };
    this.home_shelf=function() {
	return async_get.call(this,Store.shelves,"home_shelf") 
    };
    this.book_collection=function() {  
	return async_get.call(this,Store.collections,"collection") 
    };
    this.owner=function() {  
	return async_get.call(this,Store.users,"owner") 
    };
    this.borrower=function() {
	return async_get.call(this,Store.users,"borrower") 
    };

}).call(Lectito.Models.Book.prototype)
