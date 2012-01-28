var previously_selected;
var shelves, collections, books;

Lectito.Views.ULView=Backbone.View.extend({
    tagName: 'ul',
    li_for_collection: function(coll) {
	name = this.options.name || 'name';
	return coll.map(function(s) {
	    var sel = (s.get('selected')) ? "class=selected" : "";
	    return "<li "+sel+" data-id="+s.get('id')+">"+s.escape(name)+"</li>" 
	}).join("\n");
    },
    initialize: function() {
	this.collection.map(function(m) {m.set({selected: true})});
	this.collection.bind("all",this.render,this);
	this.render();
    },
    events: {
	"click li" : "do_select"
    },
    do_select: function(e) {
	var id=$(e.target).closest("li").data("id");
	var m=this.collection.get(id);
	var selected= (m.has('selected')) ? m.get('selected') : false;
	m.set({selected:  !selected});
    },
    render: function() {
	$(this.el).html(this.li_for_collection(this.collection));
	return this;
    }
}); 
var debugv;
_.templateSettings = {
    escape : /\{\{(.+?)\}\}/g,
};

Lectito.Views.BookView=Backbone.View.extend({
    tagName: 'tr',
    render: function() {
	var templ=$('#booklist_row_template').html();
	var m=this.model;
	var e=m.get('edition');
	var cs=m.get('current_shelf_id');
	var data={
	    id: m.get('id'),
	    current_shelf: (cs ? shelves.get(cs).get('name') : ""),
	    home_shelf: shelves.get(m.get('home_shelf_id')).get('name'),
	    author: e['author'], title: e['title'],
	    created_at: $.timeago(m.get('created_at'))
	};
	var html=_.template(templ,data);
	$(this.el).html(html);
	return this;
    }
});
Lectito.Views.BooksView=Backbone.View.extend({
    tagName: 'tbody',
    initialize: function() {
	this.collection.bind("all",this.render,this);
	shelves.bind("change",this.render,this);
	collections.bind("change",this.render,this);
    },
    where: function(row) {
	var s=(shelves.get(row.get('home_shelf_id')).get('selected') &&
	       collections.get(row.get('collection_id')).get('selected'));
	return s;
    },
    renderItem: function(book) {
	var iv = new Lectito.Views.BookView({model: book});
	iv.render();
	$(this.el).append(iv.el);
    },
    render: function() {
	$(this.el).html("");
	this.collection.filter(this.where).map(this.renderItem,this);
	return this;
    }
});



jQuery(document).ready(function() {
    if(($('body').data('controller')=='books') &&
       ($('body').data('action')=='index')) {
	books = new Lectito.Collections.BooksCollection();
	collections = new Lectito.Collections.CollectionsCollection();
	shelves = new Lectito.Collections.ShelvesCollection();
	shelves.reset(shelf_data);
	collections.reset(collection_data);
	books.reset(book_data);
	var collectionsView=new Lectito.Views.ULView({
	    collection: collections
	});
	var shelvesView=new Lectito.Views.ULView({collection: shelves});
	var booksView=new Lectito.Views.BooksView({collection: books});
	$('#collections').append(collectionsView.render().el);
	$('#shelves').append(shelvesView.render().el);
	$('#booklist').append(booksView.render().el);
	debugv=booksView;
    }
});


// =================================================

jQuery(document).ready(function() {
	if(($('body').data('controller')=='books') &&
	   ($('body').data('action')=='inadex')) {
	    $('select#mark').change(function(e) {
		    var v=e.target.value;
		    var sel='td.check input[type=checkbox]';
		    if(v=='all') {
			$(sel).attr("checked","checked");
		    } else if(v=='none') {
			$(sel).removeAttr("checked");
		    } else if(v=='invert') {
			$(sel).map(function(i,el) {
				if(el.checked) $(el).removeAttr("checked");
				else $(el).attr("checked","checked");
			    });
		    }
		    e.preventDefault();
		    e.target.value='title';
		});
	    $('input[type=checkbox]').click(function(e) {
		    // mimic the gmail behaviour for shift-clicks:
		    // if this box is to be checked, also check
		    // every box between this one and the previous most recently
		    // clicked box.  If to be unchecked, uncheck
		    // likewise
		    if(e.shiftKey && previously_selected) {
			var tr=$(e.target).closest("tr");
			var rng=tr.nextUntil(previously_selected);
			// nextUntil returns all following siblings if 
			// the arg selector is not found, hence this rather
			// involved test to see if we should be looking upward
			// or downward
			if (!rng.last().next().length) {
			    rng=previously_selected.nextUntil(tr);
			}
			rng.map(function(i,el) { $("input[type=checkbox]",el)[0].checked=e.target.checked});		    
		    }
		    previously_selected=$(e.target).closest("tr");
		    
		});
	    
	    $("table th").click(function(e) {
		    if (this.id == 'check') { return; };
		    var sort_key=e.target.firstChild.textContent.toLowerCase();
		    var params=document.location.search.substr(1).split('&').reduce(function(h,p) { var kv=p.split('=',2); h[kv[0]]=kv[1] ; return h }, {});
		    if (params.sort==sort_key) {
			params.direction = (params.direction == 'a') ? 'd' : 'a';
		    } else {
			params.sort=sort_key;
			params.direction = 'a';
		    };
		    params.page='1';
		    var  p_new=$.map(params,function(v,k) { return k+"="+v }).join("&");
		    document.location=document.location.pathname+"?"+p_new;
		});
	}});

