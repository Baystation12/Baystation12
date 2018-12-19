/mob/living/exosuit/proc/dismantle()

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	var/obj/structure/heavy_vehicle_frame/frame = new(get_turf(src))
	for(var/hardpoint in hardpoints)
		remove_system(hardpoint, force = 1)
	hardpoints.Cut()

	if(arms)
		frame.arms = arms
		arms.forceMove(frame)
		arms = null
	if(legs)
		frame.legs = legs
		legs.forceMove(frame)
		legs = null
	if(body)
		frame.body = body
		body.forceMove(frame)
		body = null
	if(head)
		frame.head = head
		head.forceMove(frame)
		head = null

	frame.is_wired = 2
	frame.is_reinforced = 3
	frame.set_name = name
	frame.name = "frame of \the [frame.set_name]"
	frame.queue_icon_update()

	qdel(src)

/mob/living/exosuit/proc/install_system(var/obj/item/system, var/system_hardpoint, var/mob/user)

	if(hardpoints_locked || hardpoints[system_hardpoint])
		return 0

	if(user)
		var/delay = 30 * user.skill_delay_mult(SKILL_DEVICES)
		if(delay > 0)
			user.visible_message(SPAN_NOTICE("\The [user] begins trying to install \the [system] into \the [src]."))
			if(!do_after(user, delay, src) || user.get_active_hand() != system)
				return FALSE

	var/obj/item/mech_equipment/ME = system
	if(istype(ME))
		if(ME.restricted_hardpoints && !(system_hardpoint in ME.restricted_hardpoints))
			return 0
		if(ME.restricted_software)
			if(!head || !head.software)
				return 0
			var/found
			for(var/software in ME.restricted_software)
				if(software in head.software.installed_software)
					found = 1
					break
			if(!found)
				return 0
		ME.installed(src)

	if(user)
		user.unEquip(system)
		to_chat(user, SPAN_NOTICE("You install \the [system] in \the [src]'s [system_hardpoint]."))
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	system.forceMove(src)
	hardpoints[system_hardpoint] = system

	var/obj/screen/movable/exosuit/hardpoint/H = hardpoint_hud_elements[system_hardpoint]
	H.holding = system

	system.screen_loc = H.screen_loc
	system.hud_layerise()

	hud_elements |= system
	refresh_hud()
	queue_icon_update()

	return 1

/mob/living/exosuit/proc/remove_system(var/system_hardpoint, var/mob/user, var/force)

	if((hardpoints_locked && !force) || !hardpoints[system_hardpoint])
		return 0

	var/obj/item/system = hardpoints[system_hardpoint]
	if(user)
		var/delay = 30 * user.skill_delay_mult(SKILL_DEVICES)
		if(delay > 0)
			user.visible_message(SPAN_NOTICE("\The [user] begins trying to remove \the [system] from \the [src]."))
			if(!do_after(user, delay, src) || hardpoints[system_hardpoint] != system)
				return FALSE

	hardpoints[system_hardpoint] = null

	if(system_hardpoint == selected_hardpoint)
		clear_selected_hardpoint()

	var/obj/item/mech_equipment/ME = system
	if(istype(ME))
		ME.uninstalled()
	system.forceMove(get_turf(src))
	system.screen_loc = null
	system.layer = initial(system.layer)

	var/obj/screen/movable/exosuit/hardpoint/H = hardpoint_hud_elements[system_hardpoint]
	H.holding = null

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot && pilot.client)
			pilot.client.screen -= system

	hud_elements -= system
	refresh_hud()
	queue_icon_update()

	if(user)
		system.forceMove(get_turf(user))
		user.put_in_hands(system)
		to_chat(user, SPAN_NOTICE("You remove \the [system] from \the [src]'s [system_hardpoint]."))
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	return 1

