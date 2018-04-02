/client/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"

	if (!dbcon || !dbcon.IsConnected())
		usr << "<span class='adminnotice'>The Database is not connected!</span>"
		return

	config.panic_bunker = !config.panic_bunker
	log_and_message_admins("[key_name(usr)] has [config.panic_bunker ? "enabled" : "disabled"] the Panic Bunker")
	