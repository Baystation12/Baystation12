/datum/computer_file/program/forceauthorization
	filename = "forceauthorization"
	filedesc = "Use of Force Authorization Manager"
	extended_desc = "Control console used to activate the NT Mk30-S NL authorization chip."
	size = 4
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

	data["guns"] = list()
	for(var/obj/item/weapon/gun/energy/secure/G in GLOB.registered_weapons)
		var/turf/T = get_turf(G)
		if(!T || !(T.z in GLOB.using_map.station_levels))
			continue

		var/list/modes = list()
		for(var/i = 1 to G.firemodes.len)
			if(G.authorized_modes[i] == ALWAYS_AUTHORIZED)
				continue
			var/datum/firemode/firemode = G.firemodes[i]
			modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes[i]))

		data["guns"] += list(list("name" = "[G]", "ref" = "\ref[G]", "owner" = G.registered_owner, "modes" = modes, "loc" = list("x" = T.x, "y" = T.y, "z" = T.z)))

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "forceauthorization.tmpl", name, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/forceauthorization/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["gun"] && ("authorize" in href_list) && href_list["mode"])
		var/obj/item/weapon/gun/energy/secure/G = locate(href_list["gun"]) in GLOB.registered_weapons
		var/do_authorize = text2num(href_list["authorize"])
		var/mode = text2num(href_list["mode"])
		return isnum(do_authorize) && isnum(mode) && G && G.authorize(mode, do_authorize, usr.name)

	return 0
