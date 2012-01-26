var previously_selected;

jQuery(document).ready(function() {
	if(($('body').data('controller')=='books') &&
	   ($('body').data('action')=='index')) {
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

