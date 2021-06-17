/*********************************
For the main html chat area
*********************************/

//Precaching a bunch of shit
GLOBAL_DATUM_INIT(iconCache, /savefile, new("data/tmp/iconCache.sav")) //Cache of icons for the browser output

//Should match the value set in the browser js
#define MAX_COOKIE_LENGTH 5
#define SPAM_TRIGGER_AUTOMUTE 10

//On client, created on login
/datum/chatOutput
	var/client/owner	 //client ref
	// How many times client data has been checked
	var/total_checks = 0
	// When to next clear the client data checks counter
	var/next_time_to_clear = 0
	var/loaded       = FALSE // Has the client loaded the browser output area?
	var/list/messageQueue //If they haven't loaded chat, this is where messages will go until they do
	var/cookieSent   = FALSE // Has the client sent a cookie for analysis
	var/broken       = FALSE
	var/list/connectionHistory //Contains the connection history passed from chat cookie

/datum/chatOutput/New(client/C)
	owner = C
	messageQueue = list()
	connectionHistory = list()

/datum/chatOutput/proc/start()
	//Check for existing chat
	if(!owner)
		return FALSE

	if(!winexists(owner, "browseroutput")) // Oh goddamnit.
		set waitfor = FALSE
		broken = TRUE
		message_admins("Couldn't start chat for [key_name_admin(owner)]!")
		. = FALSE
		alert(owner.mob, "Updated chat window does not exist. If you are using a custom skin file please allow the game to update.")
		return

	//It seems if someone disconnects while loading this can runtime, so we have to check for owner again
	if(owner && winget(owner, "browseroutput", "is-visible") == "true") //Already setup
		doneLoading()

	else //Not setup
		load()

	return TRUE

/datum/chatOutput/proc/load()
	set waitfor = FALSE
	if(!owner)
		return

	var/datum/asset/stuff = get_asset_datum(/datum/asset/group/goonchat)
	stuff.send(owner)

	show_browser(owner, file('code/modules/goonchat/browserassets/html/browserOutput.html'), "window=browseroutput")

/datum/chatOutput/Topic(href, list/href_list)
	if(usr.client != owner)
		return TRUE

	// Build arguments.
	// Arguments are in the form "param[paramname]=thing"
	var/list/params = list()
	for(var/key in href_list)
		if(length(key) > 7 && findtext(key, "param")) // 7 is the amount of characters in the basic param key template.
			var/param_name = copytext(key, 7, -1)
			var/item       = href_list[key]

			params[param_name] = item

	var/data // Data to be sent back to the chat.
	switch(href_list["proc"])
		if("doneLoading")
			data = doneLoading(arglist(params))

		if("debug")
			data = debug(arglist(params))

		if("ping")
			data = ping(arglist(params))

		if("analyzeClientData")
			data = analyzeClientData(arglist(params))

		if("swaptodarkmode")
			swaptodarkmode()

		if("swaptolightmode")
			swaptolightmode()

	if(data)
		ehjax_send(data = data)


//Called on chat output done-loading by JS.
/datum/chatOutput/proc/doneLoading()
	if(loaded)
		return

	loaded = TRUE
	showChat()


	for(var/message in messageQueue)
		// whitespace has already been handled by the original to_chat
		to_chat(owner, message, handle_whitespace=FALSE)

	messageQueue = null
	sendClientData()

	syncRegex()

	//do not convert to to_chat()
	legacy_chat(owner, "<span class=\"userdanger\">Failed to load fancy chat, reverting to old chat. Certain features won't work.</span>")

	pingLoop()

/datum/chatOutput/proc/showChat()
	winset(owner, "output", "is-visible=false")
	winset(owner, "browseroutput", "is-disabled=false;is-visible=true")

/datum/chatOutput/proc/pingLoop()
	set waitfor = FALSE

	while (owner)
		ehjax_send(data = owner.is_afk(29) ? "softPang" : "pang") // SoftPang isn't handled anywhere but it'll always reset the opts.lastPang.
		sleep(30)

/proc/syncChatRegexes()
	for (var/user in GLOB.clients)
		var/client/C = user
		var/datum/chatOutput/Cchat = C.chatOutput
		if (Cchat && !Cchat.broken && Cchat.loaded)
			Cchat.syncRegex()

/datum/chatOutput/proc/syncRegex()
	var/list/regexes = list()

	if (regexes.len)
		ehjax_send(data = list("syncRegex" = regexes))

/datum/chatOutput/proc/ehjax_send(client/C = owner, window = "browseroutput", data)
	if(islist(data))
		data = json_encode(data)
	send_output(C, "[data]", "[window]:ehjaxCallback")

//Sends client connection details to the chat to handle and save
/datum/chatOutput/proc/sendClientData()
	//Get dem deets
	var/list/deets = list("clientData" = list())
	deets["clientData"]["ckey"] = owner.ckey
	deets["clientData"]["ip"] = owner.address
	deets["clientData"]["compid"] = owner.computer_id
	var/data = json_encode(deets)
	ehjax_send(data = data)

//Called by client, sent data to investigate (cookie history so far)
/datum/chatOutput/proc/analyzeClientData(cookie = "")
	//Spam check
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
			connectionHistory = connData["connData"] //lol fuck
			var/list/found = new()

			if(connectionHistory.len > MAX_COOKIE_LENGTH)
				message_admins("[key_name(src.owner)] was kicked for an invalid ban cookie)")
				qdel(owner)
				return

			for(var/i in connectionHistory.len to 1 step -1)
				if(QDELETED(owner))
					//he got cleaned up before we were done
					return
				var/list/row = src.connectionHistory[i]
				if (!row || row.len < 3 || (!row["ckey"] || !row["compid"] || !row["ip"])) //Passed malformed history object
					return
				if (world.IsBanned(row["ckey"], row["ip"], row["compid"]))
					found = row
					break
				CHECK_TICK

			//Uh oh this fucker has a history of playing on a banned account!!
			if (found.len > 0)
				var/msg = "[key_name(src.owner)] has a cookie from a banned account! (Matched: [found["ckey"]], [found["ip"]], [found["compid"]])"
				//TODO: add a new evasion ban for the CURRENT client details, using the matched row details
				message_admins(msg)
				log_admin(msg)

	cookieSent = TRUE

//Called by js client every 60 seconds
/datum/chatOutput/proc/ping()
	return "pong"

//Called by js client on js error
/datum/chatOutput/proc/debug(error)
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
			var/client/C = CLIENT_FROM_VAR(I) //Grab us a client if possible

			if (!C)
				continue

			//Send it to the old style output window.
			legacy_chat(C, original_message)

			if(!C.chatOutput || C.chatOutput.broken) // A player who hasn't updated his skin file.
				continue

			if(!C.chatOutput.loaded)
				//Client still loading, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			send_output(C, twiceEncoded, "browseroutput:output")
	else
		var/client/C = CLIENT_FROM_VAR(target) //Grab us a client if possible

		if (!C)
			return

		//Send it to the old style output window.
		legacy_chat(C, original_message)

		if(!C.chatOutput || C.chatOutput.broken) // A player who hasn't updated his skin file.
			return

		if(!C.chatOutput.loaded)
			//Client still loading, put their messages in a queue
			C.chatOutput.messageQueue += message
			return

		// url_encode it TWICE, this way any UTF-8 characters are able to be decoded by the Javascript.
		send_output(C, url_encode(url_encode(message)), "browseroutput:output")

/proc/to_chat(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	set waitfor = FALSE
	if(Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized)
		to_chat_immediate(target, message, handle_whitespace, trailing_newline)
		return
	SSchat.queue(target, message, handle_whitespace, trailing_newline)

/datum/chatOutput/proc/swaptolightmode() //Dark mode light mode stuff. Yell at KMC if this breaks! (See darkmode.dm for documentation)
	owner.force_white_theme()

/datum/chatOutput/proc/swaptodarkmode()
	owner.force_dark_theme()

#undef MAX_COOKIE_LENGTH
