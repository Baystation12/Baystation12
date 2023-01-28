GLOBAL_VAR(managed_browser_id_ticker)

// This holds information on managing a /datum/browser object.
// Managing can include things like persisting the state of specific information inside of this object, receiving Topic() calls, or deleting itself when the window is closed.
// This is useful for browser windows to be able to stand 'on their own' instead of being tied to something in the game world, like an object or mob.
/datum/managed_browser
	var/client/my_client = null
	var/browser_id = null
	var/base_browser_id = null

	var/title = null
	var/size_x = 200
	var/size_y = 400

	var/display_when_created = TRUE

/datum/managed_browser/New(client/new_client)
	if(!new_client)
		crash_with("Managed browser object was not given a client.")
		return
	if(!base_browser_id)
		crash_with("Managed browser object does not have a base browser id defined in its type.")
		return

	my_client = new_client
	browser_id = "[base_browser_id]-[GLOB.managed_browser_id_ticker++]"

	if(display_when_created)
		display()

/datum/managed_browser/Destroy()
	my_client = null
	return ..()

// Override if you want to have the browser title change conditionally.
// Otherwise it's easier to just change the title variable directly.
/datum/managed_browser/proc/get_title()
	return title

// Override to display the html information.
// It is suggested to build it with a list, and use list.Join() at the end.
// This helps prevent excessive concatination, which helps preserves BYOND's string tree from becoming a laggy mess.
/datum/managed_browser/proc/get_html()
	return

/datum/managed_browser/proc/display()
	interact(get_html(), get_title(), my_client)

/datum/managed_browser/proc/interact(html, title, client/C)
	var/datum/browser/popup = new(C.mob, browser_id, title, size_x, size_y, src)
	popup.set_content(html)
	popup.open()
