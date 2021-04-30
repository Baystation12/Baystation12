// main search functionality
var last_filter = "";
function updateSearch(refid) {
	var filter = document.getElementById('filter').value.toLowerCase();
	var vars_ol = document.getElementById("vars");

	if (filter === last_filter) {
		// An event triggered an update but nothing has changed.
		return;
	} else if (filter.indexOf(last_filter) === 0) {
		// The new filter starts with the old filter, fast path by removing only.
		var children = vars_ol.childNodes;
		for (var i = children.length - 1; i >= 0; --i) {
			try {
				var li = children[i];
				if (li.innerText.toLowerCase().indexOf(filter) == -1) {
					vars_ol.removeChild(li);
				}
			} catch(err) {}
		}
	} else {
		// Remove everything and put back what matches.
		while (vars_ol.hasChildNodes()) {
			vars_ol.removeChild(vars_ol.lastChild);
		}

		for (var i = 0; i < complete_list.length; ++i) {
			try {
				var li = complete_list[i];
				if (!filter || li.innerText.toLowerCase().indexOf(filter) != -1) {
					vars_ol.appendChild(li);
				}
			} catch(err) {}
		}
	}

	last_filter = filter;
	document.cookie="[refid]][cookieoffset]search="+encodeURIComponent(filter);
}

function selectTextField(refid) {
	var filter_text = document.getElementById('filter');
	filter_text.focus();
	filter_text.select();
	var lastsearch = getCookie("[refid]][cookieoffset]search");
	if (lastsearch) {
		filter_text.value = lastsearch;
		updateSearch(refid);
	}
}

function loadPage(list) {
	if(list.options[list.selectedIndex].value == "") {
		return;
	}

	location.href=list.options[list.selectedIndex].value;
	list.selectedIndex = 0;
}

function getCookie(cname) {
	var name = cname + "=";
	var ca = document.cookie.split(';');
	for (var i=0; i<ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(name)==0) return c.substring(name.length,c.length);
	}
	return "";
}