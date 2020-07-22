/client/verb/reload_vchat()
	set name = "Reload VChat"
	set category = "OOC"

	//Timing
	if(src.chatOutputLoadedAt > (world.time - 10 SECONDS))
		alert(src, "You can only try to reload VChat every 10 seconds at most.")
		return

	//Log, disable
	log_debug("[key_name(src)] reloaded VChat.")
	winset(src, null, "outputwindow.htmloutput.is-visible=false;outputwindow.oldoutput.is-visible=false;outputwindow.chatloadlabel.is-visible=true")

	//The hard way
	qdel(src.chatOutput)
	chatOutput = new /datum/chatOutput(src) //veechat
	chatOutput.send_resources()
	spawn()
		chatOutput.start()