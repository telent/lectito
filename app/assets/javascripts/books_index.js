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
	this.collection.bind("all",this.render,this);
	this.$el.data("collection",this.collection);
	this.render();
    },
    events: {
	"click li" : "do_select",
	"drop li": "do_add_book"
    },
    do_select: function(e) {
	var target=$(e.target);
	var m=target.data("model");
	var was_selected= (m.has('selected')) ? m.get('selected') : false;
	m.set({selected:  !was_selected});
	var any_selected=
	    m.collection.any(function(f) {return f.get('selected')});
	var div=this.$el.closest("div.filter")
	if(any_selected) 
	    div.addClass("active");
	else
	    div.removeClass("active");
    },
    do_add_book: function(e,drop,ui) {
	var shelf=$(drop).data('model');
	var model=ui.draggable.data('model');
	model.post_attribute(this.options.collection_name,shelf.id);
    },
    render: function() {
	var ul=$(this.el);
	ul.html("");
	_.each(this.li_for_collection(this.collection),
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
	lines.bind("drop",function(e,ui) {
	    view.do_add_book.call(view,e,this,ui)
	});
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
	var books=Store.books.filter(function(c) {return c.get('selected');});
	var v=this;
	_(books).each(function(b){ 
	    var d={}
	    b.post_attribute(v.options.path,v.$('select').val());
	    b.unset('selected');
	});			     
	this.$('select').val("-1");
    },
    render: function() {
	var div=$(this.el);
	var inner="<select><option value=-1>"+this.options.title+"</option>"+
	    this.options.collection.map(function(x) {
		var n=x.get('name') || x.get('id') ;
		return "<option value="+x.id+">"+n+"</option>"
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
		// nothing // console.log("changed",_.keys(v));
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
	Store.shelves.bind("change",this.render,this);
	this.collection.bind("reset",this.handle_reset,this);
	Store.collections.bind("change",this.render,this);
	Store.tagnames.bind("change:selected",this.render,this);
	return this;
    },
    handle_reset: function() {
	this.$el.empty();
	var dad=this;
	this.bookViews=[];
	this.collection.each(function(m) {
	    var view=new Lectito.Views.BookView({model: m});
	    dad.bookViews.push(view);
	});
	this.$el.append(this.bookViews.map(function(v) {return v.el}));
	this.render(true);
    },
    render: function(first_time) {
	_(this.bookViews).each(function(v) {
	    v.render(first_time);
	});
	return this;
    }
});

Lectito.Views.Paginator=Backbone.View.extend({
    pageSize: 20,
    initialize: function() {
	this.model.bind("change",this.render,this);
	Store.books.bind("reset",this.render,this);
	this.model.fetch();
        this.render();
    },
    events: {
	"click a[rel=previous]" : "previous_page",
	"click a[rel=next]" : "next_page"
    },
    previous_page: function(e) {
	Store.books.previous_page();
	return false;
    },
    next_page: function(e) {
	var count=this.model.get('count');
	if(count > Store.books.page*this.pageSize)
  	    Store.books.next_page();
	return false;
    },
    render: function() {
	var page=Store.books.page;
	var count=this.model.get('count');
	var s=(page-1)*this.pageSize+1;
	var e=s+this.pageSize-1;
	if(e>count) e=count;
	var range=s+"-"+e+" of "+count;
	this.$el.html('<span name=num_results>Results '+range+
		      ' </span> <a rel="previous" href="#">&#9664;</a>'+
		      '<a rel="next" href="#">&#9654;</a>');
	return this;
    }
});

jQuery(document).ready(function() {
    if(($('body').data('controller')=='books') &&
       ($('body').data('action')=='index')) {
	current_user = Store.users.fetchId(user_data['id']);
	Store.shelves.reset(shelf_data);
	Store.collections.reset(collection_data);
	Store.tagnames.reset(tag_data);
	var collectionsView=new Lectito.Views.ULView({
	    collection:  Store.collections,
	    collection_name: 'collection',
	    where: function(model) {
		return (model.get('user_id')==current_user.id)
	    }

	});
	
	var shelvesView=new Lectito.Views.ULView({
	    collection: Store.shelves,
	    collection_name: 'shelf',
	    where: function(model) {
		return (model.get('user_id')==current_user.id)
	    }
	});
	var tagsView=new Lectito.Views.ULView({
	    collection: Store.tagnames,
	    collection_name: 'tagnames',
	    name: 'id',
	    where: function(model) {
		return true;
	    }
	});
	var booksView=new Lectito.Views.BooksView({collection:  Store.books});
	var paginator=new Lectito.Views.Paginator({
	    el: $('#pagination')[0],
	    model: new Lectito.Models.BookCount()
	});
	Store.books.reset(book_data);

	$('#collections').append(collectionsView.render().el);
	$('#shelves').append(shelvesView.render().el);
	$('#tags').append(tagsView.render().el);
	$('#booklist').append(booksView.render(true).el);
	var act=$('#toolbar');
	var changeShelfView=new Lectito.Views.ChangeThing({
	    collection: Store.shelves,
	    path: "shelf",
	    title: "Change shelf"
	});
	var changeCollectionView=new Lectito.Views.ChangeThing({
	    collection: Store.collections,
	    path: "collection",
	    title: "Change collection"
	});

	var addTagView=new Lectito.Views.ChangeThing({
	    collection: Store.tagnames,
	    path: "tag",
	    title: "Add tag"
	});

	$('.shelf',act).append(changeShelfView.render().el);
	$('.collection',act).append(changeCollectionView.render().el);
	$('.tags',act).append(addTagView.render().el);
	debugv=booksView;
	$('tr.header').live("click","th",function(e) {
	    var target=$(e.target);
	    var order=target.data('sort');
	    var direction=target.hasClass('ascending') ?
		'descending' : 'ascending';
	    $('th',this).removeClass('ascending').removeClass('descending')
	    target.addClass(direction);
	    Store.books.sort_by(order,direction);
	    return false;
	});
	    
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


