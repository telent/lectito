/* to do
 * 2) load only 20 results
 * 3) load subsequent results on scroll event when scrolled to bottom
 * 4) backend support for querying all users and favouring friends
*/

FriendPopup= (function(fp) {
    return _.extend(fp,{
	RowView: Backbone.View.extend({
	    className: 'line',
	    initialize: function() {
		this.model.bind("change",this.render,this);
		this.render();
	    },
	    template: _.template('<img src="{{ avatar }}" /><div class=nick>{{ nickname }}</div><div class=full>{{ fullname }}</div>'),
	    render: function(){
		var m=this.model;
		this.$el.html(this.template({
		    avatar: m.get('avatar'),
		    nickname: m.get('nickname'),
		    fullname: m.get('fullname')
		}));
		this.$el.data('model',m);
		return this;
	    }
	}),
	SearchBox: Backbone.Model.extend({}),
	SearchView: Backbone.View.extend({
	    tagName: "input",
	    attributes: {type: "text", size: 10, placeholder: "Find user"},
	    events: { "keyup": "do_input" },
	    initialize: function() {
		this.render();
		this.model.bind("change",this.render,this);
	    },
	    do_input: function(e) {
		this.model.set({term: this.$el.val()})
	    },
	    render: function() {
		this.$el.val(this.model.get("term"));
		return this;
	    },
	}),
	LazyUsersCollection: Lectito.Collections.UsersCollection.extend({
	    // the view does not display the last item in the collection:
	    // we always ask for one more than we need so we can see if 
	    // there are more to get next time
	    batchsize: 20,
	    incomplete: true,
	    on_show: 0,
	    loading: false,
	    fetch_more: function() {
		var url='/users/'+this.user.id+'/friends';
		var expected=this.on_show+this.batchsize+1;
		this.loading=true;
		var opt = {add: true,
			   url: url,			   
			   silent: true,
			   success: function(coll,resp) {
			       this.loading=false;
			       if(coll.length===expected) {
				   coll.on_show=coll.length-1;
				   coll.incomplete=true;
			       } else {
				   coll.on_show=coll.length;
				   coll.incomplete=false;
			       }
			       coll.trigger('add');
			   },
			   data: {'from': this.length, 'to': expected }
			  };
		return this.fetch(opt);
	    }
	}),
	RowsView: Backbone.View.extend({
	    id: "friend_popup",
	    events: {
		"click .line": "do_click",
	    },
	    do_click: function(e) {
		var m=$(e.currentTarget).data('model');
		this.options.callback(m,this.el);
	    },
	    do_filter: function () {
		var term=this.search.get('term');
		// when the term changes, we reset the offset to 0
		if(term.length>1) {
		    this.collection.fetch({
			url: "/users/1/friends?term="+term+"&limit=21"
		    });
		}
	    },
	    initialize: function() {
		this.search=new fp.SearchBox({term: ""});
		this.search.bind("change",this.do_filter,this);
		this.collection.bind("add",this.render,this);
		this.searchview=new fp.SearchView({model: this.search});
		this.$el.html("<div class=static></div><div class=scroller></div>");
		this.$('.static').append(this.searchview.render().el);
		this.render();
	    },
	    views: [],
	    render: function(){
		var o=this.options;
		this.views=this.collection.map(function (m) {
		    var v=new fp.RowView({model: m, callback: o.callback});
		    return v.render();
		});
		this.$('.scroller').empty().append(this.views.map(function(v){
		    return v.el
		}));

		if(this.collection.incomplete) {
		    this.views.pop();
		    this.$('.scroller').append("<div class=more>Fetch more results</div>")
		}
		var c=this.collection;
		this.$('.scroller .more').click(function (e){
		    c.fetch_more();
		});
		return this;
	    },
	})
    })
})({});

function friend_popup(user,callback) {
    friends=new FriendPopup.LazyUsersCollection();
    friends.user=user;
    var rvs=new FriendPopup.RowsView({ 
	collection: friends, 
	callback: callback
    });
    $('article').append(rvs.el);
    rvs.$el.dialog({autoOpen: false,width: 400,
		    title: 'Lend this book to'});
    rvs.$el.dialog('open');
    friends.fetch_more();
}

