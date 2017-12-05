/datum/computer_file/program/forceauthorization
	filename = "forceauthorization"
	filedesc = "Use of Force Authorization Manager"
	extended_desc = "Control console used to activate the NT Mk30-S NL authorization chip."
	size = 8
	program_icon_state = "security"
	program_menu_icon = "locked"
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access = access_armory
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/forceauthorization/

/datum/nano_module/forceauthorization/
	name = "Use of Force Authorization Manager"

/datum/nano_module/forceauthorization/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["tasers"] = list()
	for(var/obj/item/weapon/gun/energy/taser/secure/T in GLOB.secure_tasers)
		var/turf/taser_loc = get_turf(T)
		if(!taser_loc || !(taser_loc.z in GLOB.using_map.station_levels))
			continue

		var/owner = "no one"
		var/mob/living/carbon/human/H = get_holder_of_type(T, /mob/living/carbon/human)
		if(H)
			owner = H.get_id_name()

		data["tasers"] += list("ref" = "\ref[T]", "owner" = owner, "authorized" = T.authorized, "loc" = list("x" = T.x, "y" = T.y, "z" = T.z))

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "forceauthorization.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/forceauthorization/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["mass_authorize"] != null)
		for(var/obj/item/weapon/gun/energy/taser/secure/T in GLOB.secure_tasers)
			var/turf/taser_loc = get_turf(T)
			if(!taser_loc || !(taser_loc.z in GLOB.using_map.station_levels))
				continue

			. = T.authorize(text2num(href_list["mass_authorize"]), usr) || .
		return

	if(href_list["taser"] && href_list["authorize"] != null)
		var/obj/item/weapon/gun/energy/taser/secure/T = locate(href_list["taser"]) in GLOB.secure_tasers
		return T && T.authorize(text2num(href_list["authorize"]), usr)

	return 0
