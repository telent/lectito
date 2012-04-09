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
	RowsView: Backbone.View.extend({
	    id: "friend_popup",
	    events: {
		"click .line": "do_click"
	    },
	    do_click: function(e) {
		var m=$(e.currentTarget).data('model');
		console.log(m);
		this.options.callback(m,this.el);
	    },
	    initialize: function() {
		this.collection.bind("change",this.render,this);
		var o=this.options;
		this.views=this.collection.map(function (m) {
		    return new fp.RowView({model: m, callback: o.callback})
		});
		this.$el.html("<p><!-- this bit does not scroll --></p><div class=scroller></div>");
		this.$('.scroller').append(this.views.map(function(v){ return v.el}));
		this.render();
	    },
	    views: [],
	    render: function(){
		this.views.map(function(v){ v.render() });
		return this;
	    }
	})
    })
})({});

function do_friend_popup(user,coll,callback) {
    // need a friend view and a friends view which subscribe to 
    // events on the collection "coll"

    /* el is the element to which we will add the popup body.  
     * The popup body is initially hidden; after we've created it
     * we call jquery dialog() on it
     */
    var rvs=new FriendPopup.RowsView({ collection: coll, callback: callback });
    $('article').append(rvs.el);
    rvs.$el.dialog({autoOpen: false,width: 400,
		    title: 'Choose someone to lend to'});
    rvs.$el.dialog('open');

}

function friend_popup(user,callback) {
    var friends=new Lectito.Collections.UsersCollection();
    friends.fetch({url: "/users/"+user.id+"/friends",
		   success: function(coll,response) {
		       do_friend_popup(user,coll,callback)
		   }});
}
