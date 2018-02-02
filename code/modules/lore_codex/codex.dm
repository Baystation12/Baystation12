// Inherits from /book/ so it can fit on bookshelves.
/obj/item/weapon/book/codex
	name = "The Explorer's Guide to the Universe (12th Edition)"
	desc = "Contains useful information about the world around you. It seems to have been written mostly for the Expeditionary Corps, but a small SPACE logo sits at the bottom of the cover. It says Sol Gov Approved across the top."
	icon_state = "codex"
	unique = TRUE
	var/datum/lore/codex/home = null         // Top-most page.
	var/datum/lore/codex/current_page = null // Current page or category to display to the user.
	var/list/indexed_pages                   // Assoc list with search terms pointing to a ref of the page.  It's created on New().
	var/list/history                         // List of pages we previously visited.

/obj/item/weapon/book/codex/Initialize()
	. = ..()
	generate_pages()

/obj/item/weapon/book/codex/Destroy()
	current_page = null
	indexed_pages = null
	QDEL_NULL(home)
	. = ..()

/obj/item/weapon/book/codex/proc/generate_pages()
	home = new /datum/lore/codex/category/main(src) // This will also generate the others.
	current_page = home
	indexed_pages = current_page.index_page()

// Changes current_page to its parent, assuming one exists.
/obj/item/weapon/book/codex/proc/go_to_parent()
	if(current_page && current_page.parent)
		current_page = current_page.parent

// Changes current_page to a specific page or category.
/obj/item/weapon/book/codex/proc/go_to_page(var/datum/lore/codex/new_page, var/dont_record_history = FALSE)
	if(new_page) // Make sure we're not going to a null page for whatever reason.
		current_page = new_page
		if(!dont_record_history)
			LAZYADD(history, new_page)

/obj/item/weapon/book/codex/proc/quick_link(var/search_word)
	for(var/word in indexed_pages)
		if(lowertext(search_word) == lowertext(word)) // Exact matches unfortunately limit our ability to perform SEOs.
			go_to_page(indexed_pages[word])
			return

// Returns to the last visited page, based on the history list.
/obj/item/weapon/book/codex/proc/go_back()
	if(LAZYLEN(history) > 0)
		LAZYREMOVE(history, history[history.len]) // This gets rid of the current page in the history.
		if(LAZYLEN(history))
			go_to_page(history[history.len], dont_record_history = TRUE)
		else
			go_to_page(home, dont_record_history = TRUE)

/obj/item/weapon/book/codex/proc/get_tree_position()
	if(current_page)
		var/output = ""
		var/datum/lore/codex/checked = current_page
		output = "<b>[checked.name]</b>"
		while(checked.parent)
			output = "<a href='?src=\ref[src];target=\ref[checked.parent]'>[checked.parent.name]</a> \> [output]"
			checked = checked.parent
		return output

/obj/item/weapon/book/codex/proc/make_search_bar()
	var/html = {"
	<form id="submitForm" action="?">
	<input type = 'hidden' name = 'src' value = '\ref[src]'>
	<input type = 'hidden' name = 'action' value='search'>
	<label for = 'search_query'>Page Search: </label>
	<input type = 'text' name = 'search_query' id = 'search_query'>
	<input type = 'submit' value = 'Go'>
	</form>
	"}
	return html

/obj/item/weapon/book/codex/attack_self(mob/user)
	display(user)

/obj/item/weapon/book/codex/proc/display(mob/user)
	icon_state = "[initial(icon_state)]-open"
	if(!current_page)
		generate_pages()

	//"common", 'html/browser/common.css'
	send_rsc(user, 'html/browser/codex.css', "codex.css")

	var/dat = list()
	dat += "<head>"
	dat += "<title>[src.name] ([current_page.name])</title>"
	dat += "<link rel='stylesheet' href='codex.css' />"
	dat += "</head>"

	dat += "<body>"
	dat += "[get_tree_position()]<br>"
	dat += "[make_search_bar()]<br>"
	dat += "<center>"
	dat += "<h2>[current_page.name]</h2>"
	dat += "<br>"
	if(current_page.data)
		dat += "[current_page.data]<br>"
	dat += "<br>"
	if(istype(current_page, /datum/lore/codex/category))
		dat += "<div class='button-group'>"
	//	dat += "<ul>"
		var/datum/lore/codex/category/C = current_page
		for(var/datum/lore/codex/child in C.children)
		//	dat += "<a href='?src=\ref[src];target=\ref[child];class=button'>[child.name]</a><br>" // Todo, change into pretty CSS buttons.
			dat += "<a href='?src=\ref[src];target=\ref[child]' class='button'>[child.name]</a>"
	//	dat += "</ul>"
		dat += "</div>"
	dat += "<hr>"
	if(LAZYLEN(history) > 0)
		dat += "<br><a href='?src=\ref[src];go_back=1'>\[Go Back\]</a>"
	if(current_page.parent)
		dat += "<br><a href='?src=\ref[src];go_to_parent=1'>\[Go Up\]</a>"
	if(current_page != home)
		dat += "<br><a href='?src=\ref[src];go_to_home=1'>\[Go To Home\]</a>"
	dat += "</center></body>"
	show_browser(user, jointext(dat,null), "window=sol_gov_approved;size=600x550")
	onclose(user, "sol_gov_approved", src)

/obj/item/weapon/book/codex/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["target"]) // Direct link, using a ref
		var/datum/lore/codex/new_page = locate(href_list["target"])
		go_to_page(new_page)
	else if(href_list["search_query"])
		quick_link(href_list["search_query"])
	else if(href_list["go_to_parent"])
		go_to_parent()
	else if(href_list["go_back"])
		go_back()
	else if(href_list["go_to_home"])
		go_to_page(home)
	else if(href_list["quick_link"]) // Indirect link, using a (hopefully) indexed word.
		quick_link(href_list["quick_link"])
	else if(href_list["close"])
		icon_state = initial(icon_state)
		show_browser(usr, null, "window=sol_gov_approved")
		return 1
	display(usr)
	return 1