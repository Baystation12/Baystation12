/*
	Helpers related to /client
*/


/// Duck check to see if text looks like a ckey
/proc/valid_ckey(text)
	var/static/regex/matcher = new (@"^[a-z0-9]{1,30}$")
	return regex_find(matcher, text)


/// Duck check to see if text looks like a key
/proc/valid_key(text)
	var/static/regex/matcher = new (@"^[0-9A-Za-z][0-9A-Za-z_\. -]{2,29}$")
	return regex_find(matcher, text)


/// Get the client associated with ckey text if it is currently connected
/proc/ckey2client(text)
	if (valid_ckey(text))
		for (var/client/C as anything in GLOB.clients)
			if (C.ckey == text)
				return C


/// Get the client associated with key text if it is currently connected
/proc/key2client(text)
	if (valid_key(text))
		for (var/client/C as anything in GLOB.clients)
			if (C.key == text)
				return C


/// Null, or a client if thing is a client, a mob with a client, a connected ckey, or null
/proc/resolve_client(client/thing)
	if (istype(thing))
		return thing
	if (!thing)
		thing = usr
	if (ismob(thing))
		var/mob/M = thing
		return M.client
	return ckey2client(thing)


/// Null or a client from the list of connected clients, chosen by actor if actor is valid
/proc/select_client(client/actor, message = "Connected clients:", title = "Select Client")
	actor = resolve_client(actor)
	if (!actor)
		return
	return input(actor, message, title) as null | anything in GLOB.clients
