#define BAR_CAP 12

/mob/living/exosuit/proc/refresh_hud()
	if(LAZYLEN(pilots))
		for(var/thing in pilots)
			var/mob/pilot = thing
			if(pilot.client)
				pilot.client.screen |= hud_elements
	if(client)
		client.screen |= hud_elements

/mob/living/exosuit/InitializeHud()
	zone_sel = new
	if(!LAZYLEN(hud_elements))
		var/i = 1
		for(var/hardpoint in hardpoints)
			var/obj/screen/movable/exosuit/hardpoint/H = new(src, hardpoint)
			H.screen_loc = "1:6,[15-i]" //temp
			hud_elements |= H
			hardpoint_hud_elements[hardpoint] = H
			i++

		var/list/additional_hud_elements = list(
			/obj/screen/movable/exosuit/toggle/maint,
			/obj/screen/movable/exosuit/eject,
			/obj/screen/movable/exosuit/toggle/hardpoint,
			/obj/screen/movable/exosuit/toggle/hatch,
			/obj/screen/movable/exosuit/toggle/hatch_open,
			/obj/screen/movable/exosuit/radio,
			/obj/screen/movable/exosuit/rename,
			/obj/screen/movable/exosuit/toggle/camera
			)
		if(body && body.pilot_coverage >= 100)
			additional_hud_elements += /obj/screen/movable/exosuit/toggle/air
		i = 0
		var/pos = 7
		for(var/additional_hud in additional_hud_elements)
			var/obj/screen/movable/exosuit/M = new additional_hud(src)
			M.screen_loc = "1:6,[pos]:[i * -12]"
			hud_elements |= M
			i++
			if(i == 3)
				pos--
				i = 0

		hud_health = new /obj/screen/movable/exosuit/health(src)
		hud_health.screen_loc = "EAST-1:28,CENTER-3:11"
		hud_elements |= hud_health
		hud_open = locate(/obj/screen/movable/exosuit/toggle/hatch_open) in hud_elements
		hud_power = new /obj/screen/movable/exosuit/power(src)
		hud_power.screen_loc = "EAST-1:12,CENTER-4:25"
		hud_elements |= hud_power

	refresh_hud()

/mob/living/exosuit/handle_hud_icons()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/movable/exosuit/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H) H.update_system_info()
	handle_hud_icons_health()
	var/obj/item/weapon/cell/C = get_cell()
	if(istype(C))
		hud_power.maptext = "[round(get_cell().charge)]/[round(get_cell().maxcharge)]"
	else hud_power.maptext = "CHECK POWER"
	refresh_hud()

/mob/living/exosuit/handle_hud_icons_health()

	hud_health.overlays.Cut()

	if(!body || !get_cell() || (get_cell().charge <= 0))
		return

	if(!body.diagnostics || !body.diagnostics.is_functional() || ((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*2)))
		if(!GLOB.mech_damage_overlay_cache["critfail"])
			GLOB.mech_damage_overlay_cache["critfail"] = image(icon='icons/mecha/mech_hud.dmi',icon_state="dam_error")
		hud_health.overlays |= GLOB.mech_damage_overlay_cache["critfail"]
		return

	var/list/part_to_state = list("legs" = legs,"body" = body,"head" = head,"arms" = arms)
	for(var/part in part_to_state)
		var/state = 0
		var/obj/item/mech_component/MC = part_to_state[part]
		if(MC)
			if((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*3))
				state = rand(0,4)
			else
				state = MC.damage_state
		if(!GLOB.mech_damage_overlay_cache["[part]-[state]"])
			var/image/I = image(icon='icons/mecha/mech_hud.dmi',icon_state="dam_[part]")
			switch(state)
				if(1)
					I.color = "#00ff00"
				if(2)
					I.color = "#f2c50d"
				if(3)
					I.color = "#ea8515"
				if(4)
					I.color = "#ff0000"
				else
					I.color = "#f5f5f0"
			GLOB.mech_damage_overlay_cache["[part]-[state]"] = I
		hud_health.overlays |= GLOB.mech_damage_overlay_cache["[part]-[state]"]
