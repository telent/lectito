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
		if(term.length>1) {
		    this.collection.fetch({
			url: "/users/1/friends?term="+term+"&limit=21"
		    });
		}
	    },
	    initialize: function() {
		this.search=new fp.SearchBox({term: ""});
		this.search.bind("change",this.do_filter,this);
		this.collection.bind("reset",this.render,this);
		this.searchview=new fp.SearchView({model: this.search});
		this.$el.html("<div class=static></div><div class=scroller></div>");
		this.$('.static').append(this.searchview.render().el);
		this.render();
	    },
	    views: [],
	    render: function(){
		var o=this.options;
		this.views=this.collection.map(function (m) {
		    return new fp.RowView({model: m, callback: o.callback})
		});
		this.$('.scroller').empty().append(this.views.map(function(v){ return v.el}));
		this.views.map(function(v){ v.render() });
		return this;
	    }
	})
    })
})({});

function do_friend_popup(user,coll,callback) {
    var rvs=new FriendPopup.RowsView({ 
	collection: coll, 
	callback: callback
    });
    $('article').append(rvs.el);
    rvs.$el.dialog({autoOpen: false,width: 400,
		    title: 'Lend this book to'});
    rvs.$el.dialog('open');

}

function friend_popup(user,callback) {
    var friends=new Lectito.Collections.UsersCollection();
    friends.fetch({url: "/users/"+user.id+"/friends",
		   success: function(coll,response) {
		       do_friend_popup(user,coll,callback)
		   }});
}
