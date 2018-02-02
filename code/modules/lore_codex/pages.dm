// Contains the 'raw' lore data.
/datum/lore/codex
	var/name                    // Title displayed
	var/data                    // The actual words.
	var/datum/lore/codex/parent // Category above us
	var/list/keywords           // Used for searching.
	var/atom/movable/holder

/datum/lore/codex/New(var/new_holder, var/new_parent)
	..()
	holder = new_holder
	parent = new_parent
	keywords = list()
	add_content()
	if(name)
		keywords.Add(name)

/datum/lore/codex/Destroy()
	holder = null
	parent = null
	. = ..()

/datum/lore/codex/Topic(href, href_list)
	. = ..()
	if(.)
		return

	holder.Topic(href, href_list) // Redirect to the physical object

// Returns an assoc list of keywords binded to a ref of this page.  If it's a category, it will also recursively call this on its children.
/datum/lore/codex/proc/index_page()
	var/list/results = list()
	for(var/keyword in keywords)
		results[keyword] = src
	return results

// This gets called in New(), which is helpful for inserting quick_link()s.
/datum/lore/codex/proc/add_content()
	return

// Use this to quickly link to a different page
/datum/lore/codex/proc/quick_link(var/target, var/word_to_display)
	if(isnull(word_to_display))
		word_to_display = target
	return "<a href='?src=\ref[src];quick_link=[target]'>[word_to_display]</a>"

// Can only be found by specifically searching for it.
/datum/lore/codex/page/ultimate_answer
	name = "Answer to the Ultimate Question of Life, the Universe, and Everything"
	data = "42"
	keywords = list("Ultimate Question", "Ultimate Question of Life, the Universe, and Everything", "Life, the Universe, and Everything", "Everything", "42")

// Organizes pages together.
/datum/lore/codex/category
	var/list/children // Pages or more categories relevant to this category.  Self initializes from types to refs in New()

/datum/lore/codex/category/New()
	..()
	var/list/new_children_list = list()
	for(var/type in children)
		new_children_list.Add(new type(holder, src))
	children = new_children_list

/datum/lore/codex/category/Destroy()
	QDEL_NULL_LIST(children)
	. = ..()

/datum/lore/codex/category/index_page()
	// First, get our own keywords.
	var/list/results = ..()
	// Now get our children.  If a child is also a category, it will get their children too.
	for(var/datum/lore/codex/child in children)
		results += child.index_page()
	return results

/datum/lore/codex/category/main // The top-level categories
	name = "Index"
	data = "Space, the Last Frontier.\
	<br><br>\
	The many star systems inhabitied by humanity and friends can seem bewildering to the uninitiated. \
	This book provides useful information to novice Explorers of the vast void of space. Here you can find helpful information about everything \
	from the different species, the terran confederacy, information about colonies, or even about the different TSCs. Use this book wisely. \
	<i>all information provided has been approved by the Sol Central Government for distribution in the Expeditionary Corps</i>"
	children = list(
		/datum/lore/codex/category/organizations,
		/datum/lore/codex/category/species,
		/datum/lore/codex/category/tsc,
		/datum/lore/codex/category/locations,
		/datum/lore/codex/category/military,
		/datum/lore/codex/page/about
		)

/datum/lore/codex/page/about
	name = "About"
	data = "<i>The Explorer's Guide to the Universe 12th Edition</i> is a series of books detailing the comings and goings of the 26th Century.  \
	Everything provided in the Explorer's Guide has been compiled by veterans of the esteemed Expeditionary Corps and other parts of the Sol Gov Office of Diplomacy. \
	<br><br>\
	The books themselves have been distributed by SPACE Publications since the Guide's 11th Edition. All material provided within the books has been approved for publication by \
	the Sol Central Government for the purpose of providing an accurate depiction of the universe we live in today."
