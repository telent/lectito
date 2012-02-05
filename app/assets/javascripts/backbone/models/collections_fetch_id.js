(function() {
    this.fetchId=function(id,revalidate) {
	var m;
	m=this.get(id);
	if(!m) {
	    m=new this.model({id: id});
	    this.add(m,{silent: true});
	    revalidate=true;
	}
	if(revalidate && !m.has("fetching")) {
	    m.set({fetching: true},{silent: true});
	    m.fetch({success: function(m) { m.unset("fetching")}});
	}
	return m;
    }
}).call(Backbone.Collection.prototype)