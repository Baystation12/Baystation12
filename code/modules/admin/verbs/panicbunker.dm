/client/proc/panic_bunker()
	set category = "Server"
	set name = "Toggle Panic Bunker"
	if(!check_rights(R_ADMIN))
		return

	if(!config.sql_enabled)
		to_chat(usr, "<span class='warning'>The panic bunker cannot be used without the database!</span>")
		return


	config.panic_bunker = !config.panic_bunker
	log_and_message_admins("The Panic Bunker was [config.panic_bunker ? "enabled" : "disabled"] by [key_name(usr)]!")
	if(config.panic_bunker && !(dbcon && dbcon.IsConnected()))
		log_and_message_admins("<span class='warning'>The panic bunker will not function until the database is connected!</span>")

	feedback_add_details("admin_verb", "PBNK")//If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!