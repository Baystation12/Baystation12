//The 'V' is for 'VORE' but you can pretend it's for Vue.js if you really want.

//These are sent to the client via browse_rsc() in advance so the HTML can access them.
GLOBAL_LIST_INIT(vchatFiles, list(
	"code/modules/vchat/css/vchat-font-embedded.css",
	"code/modules/vchat/css/semantic.min.css",
	"code/modules/vchat/css/ss13styles.css",
	"code/modules/vchat/js/polyfills.js",
	"code/modules/vchat/js/vue.min.js",
	"code/modules/vchat/js/vchat.js"
))

// The to_chat() macro calls this proc
/proc/to_chat(var/target, var/message)
	//We attempt to log first. We cannot log unless SSchat is initialized.
	if(check_vchat())
		// First do logging in database
		if(isclient(target))
			var/client/C = target
			vchat_add_message(C.ckey, message)
		else if(ismob(target))
			var/mob/M = target
			if(M.ckey)
				vchat_add_message(M.ckey, message)
		else if(target == world)
			for(var/client/C in GLOB.clients)
				if(!QDESTROYING(C)) // Might be necessary?
					vchat_add_message(C.ckey, message)

	// Now lets either queue it for sending, or send it right now
	if(Master.current_runlevel == RUNLEVEL_INIT || !SSchat?.initialized)
		to_chat_immediate(target, world.time, message)
	else
		SSchat.queue(target, world.time, message)

//This is used to convert icons to base64 <image> strings, because byond stores icons in base64 in savefiles.
GLOBAL_DATUM_INIT(iconCache, /savefile, new("data/iconCache.sav")) //Cache of icons for the browser output

//The main object attached to clients, created when they connect, and has start() called on it in client/New()
/datum/chatOutput
	var/client/owner = null // client ref
	var/loaded = FALSE // Has the client been loaded?
	var/list/message_queue = list() // If they haven't loaded yet, this is where messages go until they do.
	var/broken = FALSE
	var/resources_sent = FALSE // Indicates if the client has received all resources.

	var/message_buffer = 200 // Number of messages being actively shown to the user, used to play back that many messages on reconnect

	var/last_topic_time = 0
	var/too_many_topics = 0
	var/topic_spam_limit = 10 //Just enough to get over the startup and such

/datum/chatOutput/New(client/C)
	. = ..()

	owner = C

/datum/chatOutput/Destroy()
	owner = null
	. = ..()

/datum/chatOutput/proc/update_vis()
	if(!loaded && !broken)
		winset(owner, null, "outputwindow.htmloutput.is-visible=false;outputwindow.oldoutput.is-visible=false;outputwindow.chatloadlabel.is-visible=true")
	else if(broken)
		winset(owner, null, "outputwindow.htmloutput.is-visible=false;outputwindow.oldoutput.is-visible=true;outputwindow.chatloadlabel.is-visible=false")
	else if(loaded)
		return //It can do it's own winsets from inside the JS if it's working.

//Shove all the assets at them
/datum/chatOutput/proc/send_resources()
	for(var/filename in GLOB.vchatFiles)
		send_rsc(owner, file(filename), filename)
	resources_sent = TRUE

//Called from client/New() in a spawn()
/datum/chatOutput/proc/start()
	if(!owner)
		qdel(src)
		return FALSE

	if(!winexists(owner, "outputwindow.htmloutput"))
		spawn()
			alert(owner, "Updated chat window does not exist. If you are using a custom skin file please allow the game to update.")
		become_broken()
		return FALSE

	//if(!owner.is_preference_enabled(/datum/client_preference/vchat_enable))
	//	become_broken()
	//	return FALSE

	//Could be loaded from a previous round, are you still there?
	if(winget(owner,"outputwindow.htmloutput","is-visible") == "true") //Winget returns strings
		send_event(event = list("evttype" = "availability"))
		sleep(3 SECONDS)

	if(!owner) // In case the client vanishes before winexists returns
		qdel(src)
		return FALSE

	if(!loaded)
		update_vis()
		if(!resources_sent)
			send_resources()
		load()

	return TRUE


//Attempts to actually load the HTML page into the client's UI
/datum/chatOutput/proc/load()
	if(!owner)
		qdel(src)
		return

	show_browser(owner, file2text("code/modules/vchat/html/vchat.html"), "window=htmloutput")

	//Check back later
	spawn(15 SECONDS)
		if(!src)
			return
		if(!src.loaded)
			src.become_broken()

//var/list/joins = list() //Just for testing with the below
//Called by Topic, when the JS in the HTML page finishes loading
/datum/chatOutput/proc/done_loading()
	if(loaded)
		return

	loaded = TRUE
	broken = FALSE
	owner.chatOutputLoadedAt = world.time

	for(var/message in message_queue)
		to_chat(owner, message)

	//message_queue = null
	//update_vis() //It does it's own winsets
	ping_cycle()
	send_playerinfo()
	if(check_vchat()) // Clients connecting right at server start may be done before we've initialized the db.
		load_database()
	else
		testing("[owner.ckey] Has completed loading but the vchat database is not ready!")

	owner.verbs += /client/proc/vchat_export_log

//Perform DB shenanigans
/datum/chatOutput/proc/load_database()
	set waitfor = FALSE
	// Only send them the number of buffered messages, instead of the ENTIRE log
	var/list/results = vchat_get_messages(owner.ckey, message_buffer) //If there's bad performance on reconnects, look no further
	for(var/i in results.len to 1 step -1)
		var/list/message = results[i]
		var/count = 10
		to_chat_immediate(owner, message["time"], message["message"])
		count++
		if(count >= 10)
			count = 0
			CHECK_TICK

//It din work
/datum/chatOutput/proc/become_broken()
	broken = TRUE
	loaded = FALSE

	if(!owner)
		qdel(src)
		return

	update_vis()

	spawn()
		alert(owner,"VChat didn't load after some time. Switching to use oldchat as a fallback. Try using 'Reload VChat' verb in OOC verbs, or reconnecting to try again.")

//Provide the JS with who we are
/datum/chatOutput/proc/send_playerinfo()
	if(!owner)
		qdel(src)
		return

	var/list/playerinfo = list("evttype" = "byond_player", "cid" = owner.computer_id, "ckey" = owner.ckey, "address" = owner.address, "admin" = owner.holder ? "true" : "false")
	send_event(playerinfo)

//Ugh byond doesn't handle UTF-8 well so we have to do this.
/proc/jsEncode(var/list/message) {
	if(!islist(message))
		CRASH("Passed a non-list to encode.")

	return url_encode(url_encode(json_encode(message)))
}

//Send a side-channel event to the chat window
/datum/chatOutput/proc/send_event(var/event, var/client/C = owner)
	to_target(C, output(jsEncode(event), "htmloutput:get_event"))

//Looping sleeping proc that just pings the client and dies when we die
/datum/chatOutput/proc/ping_cycle()
	set waitfor = FALSE
	while(!QDELING(src))
		if(!owner)
			qdel(src)
			return
		send_event(event = keep_alive())
		sleep(20 SECONDS) //Make sure this makes sense with what the js client is expecting

//Just produces a message for using in keepalives from the server to the client
/datum/chatOutput/proc/keep_alive()
	return list("evttype" = "keepalive")

//A response to a latency check from the client
/datum/chatOutput/proc/latency_check()
	return list("evttype" = "pong")

//Redirected from client/Topic when the user clicks a link that pertains directly to the chat (when src == "chat")
/datum/chatOutput/Topic(var/href, var/list/href_list)
	if(usr.client != owner)
		return 1

	if(last_topic_time > (world.time - 3 SECONDS))
		too_many_topics++
		if(too_many_topics >= topic_spam_limit)
			log_and_message_admins("Kicking [key_name(owner)] - VChat Topic() spam")
			to_chat(owner,"<span class='danger'>You have been kicked due to VChat sending too many messages to the server. Try reconnecting.</span>")
			qdel(owner)
			qdel(src)
			return
	else
		too_many_topics = 0
	last_topic_time = world.time

	var/list/params = list()
	for(var/key in href_list)
		if(length(key) > 7 && findtext(key, "param"))
			var/param_name = copytext(key, 7, -1)
			var/item = href_list[key]
			params[param_name] = item

	var/data
	switch(href_list["proc"])
		if("not_ready")
			CRASH("Tried to send a message to [owner.ckey] chatOutput before it was ready!")
		if("done_loading")
			data = done_loading(arglist(params))
		if("ping")
			data = latency_check(arglist(params))
		if("ident")
			data = bancheck(arglist(params))
		if("unloading")
			loaded = FALSE
		if("debug")
			data = debugmsg(arglist(params))

	if(href_list["showingnum"])
		message_buffer = Clamp(text2num(href_list["showingnum"]), 50, 2000)

	if(data)
		send_event(event = data)

//Print a message that was an error from a client
/datum/chatOutput/proc/debugmsg(var/message = "No String Provided")
	log_debug("VChat: [owner] got: [message]")

//Check relevant client info reported from JS
/datum/chatOutput/proc/bancheck(var/clientdata)
	var/list/info = json_decode(clientdata)
	var/ckey = info["ckey"]
	var/ip = info["ip"]
	var/cid = info["cid"]

	//Never connected? How sad!
	if(!cid && !ip && !ckey)
		return

	var/list/ban = world.IsBanned(key = ckey, address = ip, computer_id = cid)
	if(ban)
		log_and_message_admins("[key_name(owner)] has a cookie from a banned account! (Cookie: [ckey], [ip], [cid])")

//Converts an icon to base64. Operates by putting the icon in the iconCache savefile,
// exporting it as text, and then parsing the base64 from that.
// (This relies on byond automatically storing icons in savefiles as base64)
/proc/icon2base64(var/icon/icon, var/iconKey = "misc")
	if (!isicon(icon)) return FALSE

	image_to(GLOB.iconCache[iconKey], icon)
	var/iconData = GLOB.iconCache.ExportText(iconKey)
	var/list/partial = splittext(iconData, "{")
	return replacetext(copytext(partial[2], 3, -5), "\n", "")

/proc/expire_bicon_cache(key)
	if(GLOB.bicon_cache[key])
		GLOB.bicon_cache -= key
		return TRUE
	return FALSE

GLOBAL_LIST_EMPTY(bicon_cache) // Cache of the <img> tag results, not the icons
/proc/bicon(var/obj, var/use_class = 1, var/custom_classes = "")
	var/class = use_class ? "class='icon misc [custom_classes]'" : null
	if(!obj)
		return

	// Try to avoid passing bicon an /icon directly. It is better to pass it an atom so it can cache.
	if(isicon(obj)) // Passed an icon directly, nothing to cache-key on, as icon refs get reused *often*
		return "<img [class] src='data:image/png;base64,[icon2base64(obj)]'>"

	// Either an atom or somebody fucked up and is gonna get a runtime, which I'm fine with.
	var/atom/A = obj
	var/key
	var/changes_often = ishuman(A) || isobserver(A) // If this ends up with more, move it into a proc or var on atom.

	if(changes_often)
		key = "\ref[A]"
	else
		key = "[istype(A.icon, /icon) ? "\ref[A.icon]" : A.icon]:[A.icon_state]"

	var/base64 = GLOB.bicon_cache[key]
	// Non-human atom, no cache
	if(!base64) // Doesn't exist, make it.
		var/icon/I = icon(A.icon, A.icon_state, SOUTH, 1)
		//if (ishuman(A)) // Shitty workaround for a BYOND issue.
		//	var/icon/temp = I
		//	I = icon()
		//	I.Insert(temp, dir = SOUTH)

		GLOB.bicon_cache[key] = icon2base64(I, key)
		base64 = GLOB.bicon_cache[key]

	// May add a class to the img tag created by bicon
	if(use_class)
		class = "class='icon [A.icon_state] [custom_classes]'"

	return "<img [class] src='data:image/png;base64,[base64]'>"
	

//Checks if the message content is a valid to_chat message
/proc/is_valid_tochat_message(message)
	return istext(message)

//Checks if the target of to_chat is something we can send to
/proc/is_valid_tochat_target(target)
	return !istype(target, /savefile) && (ismob(target) || islist(target) || isclient(target) || target == world)

//This proc is only really used if the SSchat subsystem is unavailable (not started yet)
/proc/to_chat_immediate(target, time, message)
	if(!is_valid_tochat_message(message) || !is_valid_tochat_target(target))
		return

	else if(is_valid_tochat_message(message))
		if(istext(target))
			log_debug("Somehow, to_chat got a text as a target")
			return

		var/original_message = message
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\improper", "")
		message = replacetext(message, "\proper", "")

		if(isnull(time))
			time = world.time

		var/client/C = CLIENT_FROM_VAR(target)
		if(!C)
			return // No client? No care.

		// Send to the old output window
		legacy_chat(C, original_message)

		if(!C.chatOutput || C.chatOutput.broken) // Player who's skin isn't updated or fully intialized
			return

		if(!C.chatOutput.loaded && !check_vchat()) // Catch and handle unintialized chat messages
			C.chatOutput.message_queue += message
			return

		var/list/tojson = list("time" = time, "message" = message);
		to_target(target, output(jsEncode(tojson), "htmloutput:putmessage"))

/client/proc/vchat_export_log()
	set name = "Export chatlog"
	set category = "OOC"

	if(chatOutput.broken)
		to_chat(src, "<span class='warning'>Error: VChat isn't processing your messages!</span>")
		return

	var/list/results = vchat_get_messages(ckey)
	if(!LAZYLEN(results))
		to_chat(src, "<span class='warning'>Error: No messages found! Please inform a dev if you do have messages!</span>")
		return

	var/o_file = "data/chatlog_tmp/[ckey]_chat_log"
	if(fexists(o_file) && !fdel(o_file))
		to_chat(src, "<span class='warning'>Error: Your chat log is already being prepared. Please wait until it's been downloaded before trying to export it again.</span>")
		return

	o_file = file(o_file)

	// Write the CSS file to the log
	to_file(o_file, "<html><head><style>")
	to_file(o_file, file2text(file("code/modules/vchat/css/ss13styles.css")))
	to_file(o_file, "</style></head><body>")

	// Write the messages to the log
	for(var/list/result in results)
		to_file(o_file, "[result["message"]]<br>")

	to_file(o_file, "</body></html>")

	// Send the log to the client
	to_target(src, ftp(o_file, "log_[time2text(world.timeofday, "YYYY_MM_DD_(hh_mm)")].html"))

	// clean up the file on our end
	spawn(10 SECONDS)
		if(!fdel(o_file))
			spawn(1 MINUTE)
				if(!fdel(o_file))
					log_debug("Warning: [ckey]'s chatlog could not be deleted one minute after file transfer was initiated. It is located at 'data/chatlog_tmp/[ckey]_chat_log' and will need to be manually removed.")