//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/debug_antagonist_template(antag_type as null|anything in GLOB.all_antag_types_)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	if (!antag_type)
		return

	var/datum/antagonist/antag = GLOB.all_antag_types_[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")

/client/proc/debug_controller(controller as null|anything in list("Jobs","Sun","Radio","Evacuation","Configuration","pAI", "Cameras", "Transfer Controller", "Gas Data","Plants","Wireless","Observation","Alt Appearance Manager","Datacore","Military Branches"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder || !controller)
		return

	switch(controller)
		if("Radio")
			debug_variables(radio_controller)
		if("Evacuation")
			debug_variables(evacuation_controller)
		if("Configuration")
			debug_variables(config)
		if("pAI")
			debug_variables(paiController)
		if("Cameras")
			debug_variables(cameranet)
		if("Transfer Controller")
			debug_variables(transfer_controller)
		if("Gas Data")
			debug_variables(gas_data)
		if("Alt Appearance Manager")
			debug_variables(appearance_manager)
		if("Military Branches")
			debug_variables(mil_branches)
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
