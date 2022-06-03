/*********************************
For the main html chat area
*********************************/

/// Cache of icons for the browser output
GLOBAL_DATUM_INIT(iconCache, /savefile, new("data/tmp/iconCache.sav"))


/// Should match the value set in the browser js
#define MAX_COOKIE_LENGTH 5
#define SPAM_TRIGGER_AUTOMUTE 10

/client/var/chatOutput/chatOutput

/client/New()
	chatOutput = new (src)
	return ..()

/// Member of /client that manages caching and sending messages to its holder
/chatOutput
	var/client/owner

	/// How many times client data has been checked
	var/total_checks = 0

	/// When to next clear the client data checks counter
	var/next_time_to_clear = 0

	/// Has the client loaded the browser output area?
	var/loaded = FALSE

	/// If they haven't loaded chat, this is where messages will go until they do
	var/list/messageQueue = list()

	/// Has the client sent a cookie for analysis
	var/cookieSent = FALSE

	/// The client's skin prevented loading
	var/broken = FALSE

	/// Contains the connection history passed from chat cookie
	var/list/connectionHistory = list()


/chatOutput/Destroy(force)
	SSping.chats -= src
	return ..()


/chatOutput/New(client/C)
	SSping.chats += src
	owner = C


/chatOutput/proc/start()
	if (!owner)
		return FALSE
	if (!winexists(owner, "browseroutput"))
		set waitfor = FALSE
		broken = TRUE
		message_admins("Couldn't start chat for [key_name_admin(owner)]!")
		. = FALSE
		alert(owner.mob, "Updated chat window does not exist. If you are using a custom skin file please allow the game to update.")
		return
	if (owner && winget(owner, "browseroutput", "is-visible") == "true")
		doneLoading()
	else
		load()
	return TRUE


/chatOutput/proc/load()
	set waitfor = FALSE
	if(!owner)
		return
	var/datum/asset/stuff = get_asset_datum(/datum/asset/group/goonchat)
	stuff.send(owner)
	show_browser(owner, file('code/modules/goonchat/browserassets/html/browserOutput.html'), "window=browseroutput")


/chatOutput/Topic(href, list/href_list)
	if(usr.client != owner)
		return TRUE
	var/list/params = list() // Build proc parameters from the form "param[paramname]=thing"
	for(var/key in href_list)
		if(length(key) > 7 && findtext(key, "param")) // 7 is the amount of characters in the basic param key template.
			params[copytext(key, 7, -1)] = href_list[key]
	var/data // Data to be sent back to the chat.
	switch(href_list["proc"])
		if ("doneLoading")
			data = doneLoading(arglist(params))
		if ("debug")
			data = debug(arglist(params))
		if ("ping")
			data = ping(arglist(params))
		if ("analyzeClientData")
			data = analyzeClientData(arglist(params))
		if ("swaptodarkmode")
			swaptodarkmode()
		if ("swaptolightmode")
			swaptolightmode()
	if(data)
		ehjax_send(data = data)


//Called on chat output done-loading by JS.
/chatOutput/proc/doneLoading()
	if(loaded)
		return
	loaded = TRUE
	showChat()
	for(var/message in messageQueue)
		to_chat(owner, message, handle_whitespace = FALSE) // whitespace has already been handled by the original to_chat
	messageQueue = null
	sendClientData()
	syncRegex()
	legacy_chat(owner, SPAN_DANGER("Failed to load fancy chat. Some features won't work.")) // do NOT convert to to_chat()


/chatOutput/proc/showChat()
	winset(owner, "output", "is-visible=false")
	winset(owner, "browseroutput", "is-disabled=false;is-visible=true")


/chatOutput/proc/updatePing()
	if (!owner)
		qdel(src)
		return
	ehjax_send(data = owner.is_afk(29 SECONDS) ? "softPang" : "pang")


/proc/syncChatRegexes()
	for (var/user in GLOB.clients)
		var/client/C = user
		var/chatOutput/Cchat = C.chatOutput
		if (Cchat && !Cchat.broken && Cchat.loaded)
			Cchat.syncRegex()


/chatOutput/proc/syncRegex()
	var/list/regexes = list()
	if (regexes.len)
		ehjax_send(data = list("syncRegex" = regexes))


/chatOutput/proc/ehjax_send(client/C = owner, window = "browseroutput", data)
	if(islist(data))
		data = json_encode(data)
	send_output(C, "[data]", "[window]:ehjaxCallback")


//Sends client connection details to the chat to handle and save
/chatOutput/proc/sendClientData()
	var/list/deets = list("clientData" = list())
	deets["clientData"]["ckey"] = owner.ckey
	deets["clientData"]["ip"] = owner.address
	deets["clientData"]["compid"] = owner.computer_id
	var/data = json_encode(deets)
	ehjax_send(data = data)


//Called by client, sent data to investigate (cookie history so far)
/chatOutput/proc/analyzeClientData(cookie = "")
	if(world.time  >  next_time_to_clear)
		next_time_to_clear = world.time + (3 SECONDS)
		total_checks = 0
	total_checks += 1
	if(total_checks > SPAM_TRIGGER_AUTOMUTE)
		message_admins("[key_name(owner)] kicked for goonchat topic spam")
		qdel(owner)
		return
	if(!cookie)
		return
	if(cookie != "none")
		var/list/connData = json_decode(cookie)
		if (connData && islist(connData) && connData.len > 0 && connData["connData"])
			connectionHistory = connData["connData"]
			var/list/found = new()
			if(connectionHistory.len > MAX_COOKIE_LENGTH)
				message_admins("[key_name(src.owner)] was kicked for an invalid ban cookie)")
				qdel(owner)
				return
			for(var/i in connectionHistory.len to 1 step -1)
				if(QDELETED(owner))
					return
				var/list/row = src.connectionHistory[i]
				if (!row || row.len < 3 || (!row["ckey"] || !row["compid"] || !row["ip"]))
					return
				if (world.IsBanned(row["ckey"], row["ip"], row["compid"]))
					found = row
					break
				CHECK_TICK
			if (found.len > 0)
				var/msg = "[key_name(src.owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])"
				message_admins(msg)
				log_admin(msg)
	cookieSent = TRUE


//Called by js client every 60 seconds
/chatOutput/proc/ping()
	return "pong"


//Called by js client on js error
/chatOutput/proc/debug(error)
	log_world("\[[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]\] Client: [(src.owner.key ? src.owner.key : src.owner)] triggered JS error: [error]")


//Global chat procs
/proc/to_chat_immediate(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	if(!target || !message)
		return
	if(target == world)
		target = GLOB.clients
	var/original_message = message
	if(handle_whitespace)
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\t", "[FOURSPACES][FOURSPACES]")
	//Replace expanded \icon macro with icon2html
	//regex/Replace with a proc won't work here because icon2html takes target as an argument and there is no way to pass it to the replacement proc
	//not even hacks with reassigning usr work
	var/regex/i = new(@/<IMG CLASS=icon SRC=(\[[^]]+])(?: ICONSTATE='([^']+)')?>/, "g")
	while(regex_find(i, message))
		message = copytext(message,1,i.index)+icon2html(locate(i.group[1]), target, icon_state=i.group[2])+copytext(message,i.next)

	if(trailing_newline)
		message += "<br>"

	if(islist(target))
		// Do the double-encoding outside the loop to save nanoseconds
		var/twiceEncoded = url_encode(url_encode(message))
		for(var/I in target)
			var/client/C = resolve_client(I) //Grab us a client if possible

			if (!C)
				continue

			//Send it to the old style output window.
			legacy_chat(C, original_message)

			if (C.get_preference_value(/datum/client_preference/goonchat) != GLOB.PREF_YES)
				continue
			if(!C.chatOutput || C.chatOutput.broken) // A player who hasn't updated his skin file.
				continue

			if(!C.chatOutput.loaded)
				//Client still loading, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			send_output(C, twiceEncoded, "browseroutput:output")
	else
		var/client/C = resolve_client(target) //Grab us a client if possible
		if (!C)
			return
		legacy_chat(C, original_message) //Send it to the old style output window.
		if (C.get_preference_value(/datum/client_preference/goonchat) != GLOB.PREF_YES)
			return
		if(!C.chatOutput || C.chatOutput.broken) // A player who hasn't updated his skin file.
			return
		if(!C.chatOutput.loaded)
			C.chatOutput.messageQueue += message //Client still loading, put their messages in a queue
			return
		// url_encode it TWICE, this way any UTF-8 characters are able to be decoded by the Javascript.
		send_output(C, url_encode(url_encode(message)), "browseroutput:output")


/proc/to_chat(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	set waitfor = FALSE
	if(Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized)
		to_chat_immediate(target, message, handle_whitespace, trailing_newline)
		return
	SSchat.queue(target, message, handle_whitespace, trailing_newline)


/chatOutput/proc/swaptolightmode() //Dark mode light mode stuff. Yell at KMC if this breaks! (See darkmode.dm for documentation)
	owner.force_white_theme()


/chatOutput/proc/swaptodarkmode()
	owner.force_dark_theme()


#undef MAX_COOKIE_LENGTH
#undef SPAM_TRIGGER_AUTOMUTE
