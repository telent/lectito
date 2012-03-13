// var previously_selected;
var current_user;

Lectito.Views.ULView=Backbone.View.extend({
    tagName: 'ul',
    li_for_collection: function(coll) {
	name = this.options.name || 'name';
	return coll.map(function(s) {
	    var cls = (s.get('selected')) ?
		"class=\"wants_droppable selected\"" : 
		"class=\"wants_droppable\"" ;
	    var el=$("<li "+cls+">"+s.escape(name)+"</li>");
	    el.data("model",s);
	    return el;
	})
    },
    initialize: function() {
	this.collection.map(function(m) {m.set({selected: true})});
	this.collection.bind("all",this.render,this);
	if(!this.options.where) this.options.where=_.identity;
	this.render();
    },
    events: {
	"click li" : "do_select",
	"drop li": "do_add_book"
    },
    do_select: function(e) {
	var m=$(e.target).closest("li").data("model");
	var selected= (m.has('selected')) ? m.get('selected') : false;
	m.set({selected:  !selected});
    },
    do_add_book: function(e,drop,ui) {
	// jquery drop events don't work with delegate, so we need to 
	// attach them with bind directly, meaning this function gets
	// called with the wrong 'this'
	var shelf=$(drop).data('model');
	var model=ui.draggable.data('model');
	model.reshelve(shelf);
    },
    render: function() {
	var ul=$(this.el);
	ul.html("");
	_.each(this.li_for_collection(this.collection.filter(this.options.where)),
	       function(ael){
		   ul.append(ael);
	       });
	
	// I am assuming this handler needs reinstalling whenever any
	// elements matching the selector are added/removed
	var lines=$('li.wants_droppable',ul);
	lines.droppable({
	    hoverClass: 'drophover',
	    tolerance: 'pointer'
	});
	var view=this;
	lines.bind("drop",function(e,ui) {view.do_add_book.call(view,e,this,ui)});
	return this;
    }
}); 
var debugv;
_.templateSettings = {
    escape : /\{\{(.+?)\}\}/g,
};

Lectito.Views.ChangeThing=Backbone.View.extend({
    tagName: 'li',
    initialize: function() {
	this.collection.bind("change",this.render,this);
	Store.books.bind("change:selected",this.set_visible,this);
	this.render();
    },
    events: {
	"change" : "change_thing",
    },
    set_visible: function() {
	var sel=Store.books.filter(function(c) {return c.get('selected');});
	if(sel.length)
	    this.$('select').removeAttr('disabled');
	else
	    this.$('select').attr('disabled','disabled');
    },
    change_thing: function() {
	var m=this.options.collection.get(this.$('select').val());
	var books=Store.books.filter(function(c) {return c.get('selected');});
	m.add_books(books);
	this.$('select').val("-1");
	_(books).each(function(b){ b.unset('selected');	});
    },
    render: function() {
	var div=$(this.el);
	var inner="<select><option value=-1>Change "+this.options.name+"</option>"+
	    this.options.collection.map(function(x) {
		return "<option value="+x.id+">"+x.get('name')+"</option>"
	    }).join("")+
	    "</select>";
	$(div).html(inner);
	return this;
    }
});

Lectito.Views.BookView=Backbone.View.extend({
    tagName: 'tr',
    className: 'booklist_row',
    initialize: function() {
	Store.users.bind("change",this.render,this);
	this.model.bind("sync",this.render,this);
    },
    events: {
	"change td.check input": "toggle_checked"
    },
    toggle_checked: function (e) {
	var inp=this.$("td.check input");
	this.model.set({'selected': inp.attr('checked')});
    },
    render: function(first_time) {
	// These may be undefined if the calls triggered AJAX requests
	// Stop rendering now and wait for the "sync" events
	var m=this.model;
	var cs=m.current_shelf();
	var hs=m.home_shelf();
	var collection=m.book_collection();
	var owner=m.owner();
	var borrower=m.borrower();
	if(_.include([cs,hs,collection,owner,borrower],undefined)) {
	    return this;
	}

	var templ=$('#booklist_row_template').html();

	if(!first_time) {
	    var v=m.changedAttributes();
	    if(v && _.keys(v).join("") == "selected") {
		this.$('input').attr("checked",m.get('selected'));
		return this;
	    } else if(v) {
		console.log("changed",_.keys(v));
	    } else {
		// not the first time and nothing changed: skip the repaint
		return this;
	    }
	}

	var my_book = (owner.id==current_user.id);
	var e=m.get('edition');

	var data={
	    id: m.id,
	    checked: false, //m.has('selected'),
	    location: my_book ? 
		(borrower ? borrower.get('nickname') : hs.get('name')) :
	    (cs ? cs.get('name') : "unshelved"),
	    author: e['author'], title: e['title'],
	    created_at: $.timeago(m.get('created_at')),
	    lender: owner.get("nickname")
	};
	var html=$(_.template(templ,data));

	if(my_book) 
	    html=_.reject(html,function(l) {return l.className=='borrowed';});
	else 
	    html=_.reject(html,function(l) {return l.className=='added';});

	$(this.el).
	    html(html).
	    data('model',m).
	    draggable({opacity: 0.6, helper: "clone"});
	return this;
    }
});
Lectito.Views.BooksView=Backbone.View.extend({
    tagName: 'tbody',
    bookViews: {},
    events: {
	"click tr td.check input": "checked_range"
    },
    checked_range: function(e) {
	if(e.shiftKey) {
	    var tr=$(e.target).closest('tr');
	    var rng=tr.nextUntil(this.selectedRange);
	    // nextUntil returns all following siblings if 
	    // the arg selector is not found, hence this rather
	    // involved test to see if we should be looking upward
	    // or downward
	    if (!rng.last().next().length) {
		rng=this.selectedRange.nextUntil(tr);
	    }
	    rng.map(function(i,el) {
		$(el).data("model").set({'selected': true});
	    });		    
	} else {
	    this.selectedRange=$(e.target).closest('tr');
	}
    },
    initialize: function() {
	this.collection.bind("all",this.render,this);
	Store.shelves.bind("change",this.render,this);
	Store.collections.bind("change",this.render,this);
	this.$el.empty();
	var dad=this;
	this.collection.each(function(m) {
	    var view=new Lectito.Views.BookView({model: m});
	    dad.bookViews[m.id]=view;
	});
	this.$el.append(_.values(this.bookViews).
			map(function(v) {return v.el}));
	return this;
    },
    where: function(row) {
	var col=row.book_collection();
	var hs=row.home_shelf();
	var cs=row.current_shelf();
	return col && col.get('selected') &&
	    ((hs && hs.get('selected')) || (cs && cs.get('selected')));
    },
    render: function() {
	var dad=this;
	_(this.collection.filter(this.where)).each(function(m) {
	    var v=dad.bookViews[m.id];
	    v.render();
	    v.$el.show();
	});
	_(this.collection.reject(this.where)).each(function(m) {
	    var v=dad.bookViews[m.id];
	    v.$el.hide();
	});
	return this;
    }
});

jQuery(document).ready(function() {
    if(($('body').data('controller')=='books') &&
       ($('body').data('action')=='index')) {
	current_user = Store.users.fetchId(user_data['id']);
	Store.shelves.reset(shelf_data);
	Store.collections.reset(collection_data);
	Store.books.reset(book_data);
	var collectionsView=new Lectito.Views.ULView({
	    collection:  Store.collections,
	    where: function(model) {
		return (model.get('user_id')==current_user.id)
	    }

	});
	var shelvesView=new Lectito.Views.ULView({
	    collection: Store.shelves,
	    where: function(model) {
		return (model.get('user_id')==current_user.id)
	    }
	});
	var booksView=new Lectito.Views.BooksView({collection:  Store.books});
	$('#collections').append(collectionsView.render().el);
	$('#shelves').append(shelvesView.render().el);
	$('#booklist').append(booksView.render(true).el);
	var act=$('#toolbar');
	var changeShelfView=new Lectito.Views.ChangeThing({
	    collection: Store.shelves,
	    name: "shelf"
	});
	var changeCollectionView=new Lectito.Views.ChangeThing({
	    collection: Store.collections,
	    name: "collection"
	});
	$('.shelf',act).append(changeShelfView.render().el);
	$('.collection',act).append(changeCollectionView.render().el);
	debugv=booksView;
	$('#mark').change(function(e) {
	    var v=e.target.value;
	    if(v=='all') 
		Store.books.each(function(b) { b.set({selected: true});});
	    else if(v=='none')
		Store.books.each(function(b) { b.set({selected: false});});
	    else if(v=='invert'){
		Store.books.each(function(b) { 
		    var s=!b.get('selected');
		    b.set({selected: s});
		});
	    }
	    e.target.value='title';
	});
    }
});


