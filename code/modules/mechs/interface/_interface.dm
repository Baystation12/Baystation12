#define BAR_CAP 12

/mob/living/heavy_vehicle/proc/refresh_hud()
	if(pilot && pilot.client)
		pilot.client.screen |= hud_elements
	if(client)
		client.screen |= hud_elements

/mob/living/heavy_vehicle/InitializeHud()

	if(!LAZYLEN(hud_elements))
		var/i = 1
		for(var/hardpoint in hardpoints)
			var/obj/screen/movable/mecha/hardpoint/H = new(src, hardpoint)
			H.screen_loc = "1:6,[15-i]" //temp
			hud_elements |= H
			hardpoint_hud_elements[hardpoint] = H
			i++

		var/list/additional_hud_elements = list(
			/obj/screen/movable/mecha/toggle/maint,
			/obj/screen/movable/mecha/eject,
			/obj/screen/movable/mecha/toggle/hardpoint,
			/obj/screen/movable/mecha/toggle/hatch,
			/obj/screen/movable/mecha/toggle/hatch_open,
			/obj/screen/movable/mecha/radio
			)
		i = 1
		var/pos = 7
		for(var/additional_hud in additional_hud_elements)
			var/obj/screen/movable/mecha/M = new additional_hud(src)
			M.screen_loc = "1:6,[pos]"
			hud_elements |= M
			i++
			if(i>=3)
				i = 0
				pos--

		hud_health = new /obj/screen/movable/mecha/health(src)
		hud_health.screen_loc = "13:28,7:15"
		hud_elements |= hud_health
		hud_open = locate(/obj/screen/movable/mecha/toggle/hatch_open) in hud_elements

	refresh_hud()

/mob/living/heavy_vehicle/handle_hud_icons()
	for(var/hardpoint in hardpoint_hud_elements)
		var/obj/screen/movable/mecha/hardpoint/H = hardpoint_hud_elements[hardpoint]
		if(H) H.update_system_info()
	handle_hud_icons_health()
	refresh_hud()

/mob/living/heavy_vehicle/handle_hud_icons_health()

	hud_health.overlays.Cut()

	if(!body.cell || (body.cell.charge <= 0))
		return

	if(!body.diagnostics || !body.diagnostics.is_functional() || ((emp_damage>EMP_GUI_DISRUPT) && prob(emp_damage*2)))
		if(!GLOB.mecha_damage_overlay_cache["critfail"])
			GLOB.mecha_damage_overlay_cache["critfail"] = image(icon='icons/mecha/mecha_hud.dmi',icon_state="dam_error")
		hud_health.overlays |= GLOB.mecha_damage_overlay_cache["critfail"]
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
		if(!GLOB.mecha_damage_overlay_cache["[part]-[state]"])
			var/image/I = image(icon='icons/mecha/mecha_hud.dmi',icon_state="dam_[part]")
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
			GLOB.mecha_damage_overlay_cache["[part]-[state]"] = I
		hud_health.overlays |= GLOB.mecha_damage_overlay_cache["[part]-[state]"]
