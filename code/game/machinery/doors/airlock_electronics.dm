//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/item/weapon/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEM_SIZE_SMALL //It should be tiny! -Agouri

	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 50)

	req_access = list(access_engine)

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = list()
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null
	var/locked = 1
	var/lockable = 1


/obj/item/weapon/airlock_electronics/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	tg_ui_interact(user)



//tgui interact code generously lifted from tgstation.
/obj/item/weapon/airlock_electronics/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
	datum/tgui/master_ui = null, datum/ui_state/state = tg_hands_state)

	tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics", src.name, 1000, 500, master_ui, state)
		ui.open()

/obj/item/weapon/airlock_electronics/ui_data(mob/user)
	var/list/data = list()
	var/list/regions = list()

	for(var/i in ACCESS_REGION_SECURITY to ACCESS_REGION_SUPPLY) //code/game/jobs/_access_defs.dm
		var/list/region = list()
		var/list/accesses = list()
		for(var/j in get_region_accesses(i))
			var/list/access = list()
			access["name"] = get_access_desc(j)
			access["id"] = j
			access["req"] = (j in src.conf_access)
			accesses[++accesses.len] = access
		region["name"] = get_region_accesses_name(i)
		region["accesses"] = accesses
		regions[++regions.len] = region
	data["regions"] = regions
	data["oneAccess"] = one_access
	data["locked"] = locked
	data["lockable"] = lockable

	return data

/obj/item/weapon/airlock_electronics/ui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("clear")
			conf_access = list()
			one_access = 0
			return TRUE
		if("one_access")
			one_access = !one_access
			return TRUE
		if("set")
			var/access = text2num(params["access"])
			if (!(access in conf_access))
				conf_access += access
			else
				conf_access -= access
			return TRUE
		if("unlock")
			if(!lockable)
				return TRUE
			if(!req_access || istype(usr,/mob/living/silicon))
				locked = 0
				last_configurator = usr.name
				return TRUE
			else
				var/obj/item/weapon/card/id/I = usr.get_active_hand()
				I = I ? I.GetIdCard() : null
				if(!istype(I, /obj/item/weapon/card/id))
					to_chat(usr, "<span class='warning'>[\src] flashes a yellow LED near the ID scanner. Did you remember to scan your ID or PDA?</span>")
					return TRUE
				if (check_access(I))
					locked = 0
					last_configurator = I.registered_name
				else
					to_chat(usr, "<span class='warning'>[\src] flashes a red LED near the ID scanner, indicating your access has been denied.</span>")
					return TRUE
		if("lock")
			if(!lockable)
				return TRUE
			locked = 1
			. = TRUE

/obj/item/weapon/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1

/obj/item/weapon/airlock_electronics/brace
	name = "airlock brace access circuit"
	req_access = list()
	locked = 0
	lockable = 0

/obj/item/weapon/airlock_electronics/brace/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = tg_deep_inventory_state)
	tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_electronics", src.name, 1000, 500, master_ui, state)
		ui.open()
