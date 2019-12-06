// Copied from View Variables.
function updateSearch() {
	var filter_text = document.getElementById('filter');
	var filter = filter_text.value.toLowerCase();
	var notes = document.getElementById('notes');
	var lis = notes.children;

	for(var i = 0; i < lis.length; i++) {
		var li = lis[i];
		if(filter == "" || li.innerText.toLowerCase().indexOf(filter) != -1) {
			li.style.display = "block";
		} else {
			li.style.display = "none";
		}
	}
}

function selectTextField() {
	var filter_text = document.getElementById('filter');
	filter_text.focus();
	filter_text.select();
}

function loadPage(list) {
	if(list.options[list.selectedIndex].value == "") {
		return;
	}
	location.href=list.options[list.selectedIndex].value;
	list.selectedIndex = 0;
}
