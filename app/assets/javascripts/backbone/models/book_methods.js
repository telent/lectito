(function() {
    this.post_attribute=function(path,value) {
	var url=this.url()+"/"+path;
	var book=this;
	jQuery.ajax(url,{
	    data: {value: value},
	    dataType: 'json',
	    type: 'POST',
	    error: function(xhr,s,e) { console.log("failed ",s,e); },
	    success: function (r,s) {
		book.set(r);
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
