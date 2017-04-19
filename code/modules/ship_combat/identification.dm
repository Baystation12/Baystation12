/obj/machinery/space_battle/identification_computer
	name = "Identification Computer"
	icon_state = "computer"
	desc = "An identification computer."
	var/list/available_access = list()
	var/list/team_members = list()
	var/obj/item/weapon/card/id/selected_id
	var/list/new_access = list()
	var/locked = 1
	var/printing_new = 0

/obj/machinery/space_battle/identification_computer/New()
	var/area/ship_battle/A = get_area(src)
	if(A && istype(A))
		req_access = list(A.team*10 - SPACE_COMMAND)
	available_access = get_access()
	team_members = get_team_members()

/obj/machinery/space_battle/identification_computer/attack_hand(var/mob/user)
	if(!(stat & (BROKEN|NOPOWER)))
		ui_interact(user)
		return
	user << "<span class='warning'>\The [src] is not responding!</span>"

/obj/machinery/space_battle/identification_computer/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id))
		if(check_access(I))
			locked = !locked
			user.visible_message("<span class='notice'>\The [user] [locked ? "locks" : "unlocks"] \the [src]!</span>")
	else
		return ..()
/obj/machinery/space_battle/identification_computer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/list/options = list()
	if(locked)
		data["menu"] = "locked"
	else if(selected_id)
		var/list/access_options = list()
		for(var/access_name in available_access)
			var/access_number = available_access[access_name]
			var/exists = 0
			if(access_number in (new_access.len ? new_access : selected_id.access))
				exists = 1
			access_options.Add(list(list(
			"name" = access_name,
			"has_already" = exists,
			"number" = access_number
			)))
		data["access"] = access_options
		testing("Access length: [access_options.len]")
		data["menu"] = "id"
	else
		for(var/mob/living/carbon/human/H in team_members)
			options += H.real_name
		data["options"] = options
		data["menu"] = "main"

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "id_computer.tmpl", "Identification", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)



/obj/machinery/space_battle/identification_computer/Topic(href, href_list)
	if(href_list["unlock"])
		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			var/obj/item/weapon/card/id/I = H.wear_id
			if(I && istype(I))
				if(check_access(I))
					H.visible_message("<span class='notice'>\The [H] unlocks \the [src]!</span>")
					locked = 0
			else
				usr << "<span class='warning'>You are not wearing an ID!</span>"
	if(href_list["refresh"])
		team_members = get_team_members()
		available_access = get_access()
	if(href_list["return"])
		selected_id.visible_message("<span class='notice'>\The [selected_id] beeps, \"Access Modification applied!\"</span>")
		selected_id.access |= new_access
		new_access.Cut()
		if(printing_new)
			selected_id.forceMove(get_turf(src))
			printing_new = 0
		selected_id = null
	if(href_list["mob"])
		var/mob_name = href_list["mob"]
		for(var/mob/living/carbon/human/H in team_members)
			if(H.real_name == mob_name)
				selected_id = H.wear_id
				if(!(selected_id && istype(selected_id)))
					selected_id = null
					usr << "<span class='warning'>\The [H.real_name] is not wearing an ID card!</span>"
				else
					new_access |= selected_id.access
	if(href_list["change_id"])
		if(!selected_id)
			usr << "<span class='warning'>ID card not found!</span>"
		else
			var/N = text2num(href_list["change_id"])
			if(N in new_access)
				new_access -= N
			else new_access += N
	if(href_list["newid"])
		printing_new = 1
		if(selected_id)
			usr << "<span class='warning'>There is already an ID in the machine!</span>"
			return 1
		var/obj/item/weapon/card/id/space_battle/I = new(src)
		selected_id = I
	src.add_fingerprint(usr)
	nanomanager.update_uis(src)

/obj/machinery/space_battle/identification_computer/proc/get_team_members()
	var/area/ship_battle/A = get_area(src)
	if(A && istype(A))
		team = A.team
	var/list/team_members = list()
	for(var/mob/living/carbon/human/H in world)
		if(src.team > 0 && H.get_team() == src.team)
			var/obj/item/weapon/card/id/I = H.wear_id
			if(I && istype(I))
				team_members += H
	return team_members

/obj/machinery/space_battle/identification_computer/proc/get_access()
	var/area/ship_battle/A = get_area(src)
	var/list/access = list()
	var/team_access = A.team*10
	if(A && istype(A))
		access["Common"] = team_access - SPACE_COMMON
		access["Firing Tubes"] = team_access - SPACE_TUBES
		access["Command"] = team_access - SPACE_COMMAND
		access["Navigation"] = team_access - SPACE_NAVIGATION
		access["Engineering"] = team_access - SPACE_ENGINEERING
		access["Security"] = team_access - SPACE_SECURITY
		access["Maintenance"] = team_access - SPACE_MAINTENANCE
		access["Fire Control"] = team_access - SPACE_FIRE_CONTROL
		access["Research"] = team_access - SPACE_RESEARCH
		access["Medical"] = team_access - SPACE_MEDIC
	return access