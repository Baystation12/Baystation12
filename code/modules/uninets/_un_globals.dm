/**
 * Associative list holding all uninets.
 * all_networks[link_type] = list of networks of type link_type
 */
/var/list/list/all_networks = list()

/**
 * Incremented when an explosion or other modification-intensive action starts, decremented when it ends.
 * Used to pause network rebuilding while modifications are ongoing, to reduce lag.
 */
/var/global/defer_uninet_rebuild = 0

//dunno
/obj/var/list/network_number = list()
/obj/var/list/networks = list()

/**
 * List holder for debugging uninets.
 */
/list_holder
	var/list/list/list = list()

/**
 * Called by "debug controller" to display the "all_networks" list.
 * @param user The user to show the list to.
 */
/proc/debug_uninets(var/client/user)
	if(istype(user))
		var/list_holder/debug = new()
		debug.list = all_networks
		user.debug_variables(debug)
