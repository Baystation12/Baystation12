/datum/admins/proc/map_template_load()
	set category = "Fun"
	set desc = "Pick a map template to load at your current location. You will be able to confirm bounds before committing."
	set name = "Map Template - Place"

	if (!check_rights(R_FUN)) return

	var/map = input(usr, "Choose a Map Template to place at your CURRENT LOCATION","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return

	var/datum/map_template/template = SSmapping.map_templates[map]

	var/turf/T = get_turf(usr)
	if(!T)
		return

	var/list/preview = list()
	for(var/S in template.get_affected_turfs(T,centered = TRUE))
		preview += image('icons/turf/overlays.dmi',S,"greenOverlay")
	usr.client.images += preview
	if(alert(usr,"Confirm location.","Template Confirm","Yes","No") == "Yes")
		if(template.load(T, centered = TRUE))
			log_and_message_admins("has placed a map template ([template.name]).")
		else
			to_chat(usr, "Failed to place map")
	usr.client.images -= preview

/datum/admins/proc/map_template_load_new_z()
	set category = "Fun"
	set desc = "Pick a map template to load as a new zlevel, or a set of new zlevels if multi-z."
	set name = "Map Template - Place In New Z"

	if(!check_rights(R_FUN))
		return
	if(GAME_STATE < RUNLEVEL_LOBBY)
		to_chat(usr, "Please wait for the master controller to initialize before loading maps!")
		return

	var/map = input(usr, "Choose a Map Template to place on a new zlevel","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return

	var/datum/map_template/template = SSmapping.map_templates[map]

	if (template.loaded && !(template.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
		var/jesus_take_the_wheel = alert(usr, "That template has already been loaded and doesn't want to be loaded again. \
			Proceeding may unpredictably break things and cause runtimes.", "Confirm load", "Cancel load", "Do you see any cops around?") == "Do you see any cops around?"
		if (!jesus_take_the_wheel)
			return

	var/new_z_centre = template.load_new_z(FALSE) // Don't skip changeturf
	if (new_z_centre)
		log_and_message_admins("has placed a map template ([template.name]) on a new zlevel.", location=new_z_centre)
	else
		to_chat(usr, "Failed to place map")

/datum/admins/proc/map_template_upload()
	set category = "Fun"
	set desc = "Upload a .dmm file to use as a map template. Any unknown types will be skipped!"
	set name = "Map Template - Upload"

	if (!check_rights(R_FUN)) return

	var/map = input(usr, "Choose a Map Template to upload to template storage","Upload Map Template") as null|file
	if(!map)
		return
	if(copytext("[map]",-4) != ".dmm")
		to_chat(usr, "Bad map file: [map]")
		return

	var/datum/map_template/M = new(list(map), "[map]")
	if(M.preload_size())
		to_chat(usr, "Map template '[map]' ready to place ([M.width]x[M.height])")
		SSmapping.map_templates[M.name] = M
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has uploaded a map template ([map])</span>")
	else
		to_chat(usr, "Map template '[map]' failed to load properly")
