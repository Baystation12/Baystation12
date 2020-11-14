GLOBAL_LIST_EMPTY(PB_bypass)

/datum/admins/proc/panicbunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"

	if(!check_rights(R_ADMIN))
		return

	if (!dbcon.IsConnected())
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled or not working!</span>")
		return

	config.panic_bunker = (!config.panic_bunker)

	log_and_message_admins("[key_name(usr)] has toggled the Panic Bunker, it is now [(config.panic_bunker?"on":"off")]")
	if (config.panic_bunker && (!dbcon || !dbcon.IsConnected()))
		message_admins("The Database is not connected! Panic bunker will not work until the connection is reestablished.")

/datum/admins/proc/addbunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Add PB Bypass"
	set desc = "Allows a given ckey to connect despite the panic bunker for a given round."
	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled or not working!</span>")
		return

	GLOB.PB_bypass |= ckey(ckeytobypass)
	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	send2irc("Panic Bunker", "[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

/datum/admins/proc/revokebunkerbypass(ckeytobypass as text)
	set category = "Server"
	set name = "Revoke PB Bypass"
	set desc = "Revoke's a ckey's permission to bypass the panic bunker for a given round."
	if(!dbcon.IsConnected())
		to_chat(usr, "<span class='adminnotice'>The Database is not enabled or not working!</span>")
		return

	GLOB.PB_bypass -= ckey(ckeytobypass)
	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	send2irc("Panic Bunker", "[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")