/obj/machinery/appliance/cooker/stove
	name = "stove"
	desc = "Don't touch it!"
	icon_state = "stove"
	cook_type = "seared"
	use_container_cook_type = TRUE
	appliancetype = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_SAUCEPAN | COOKING_APPLIANCE_POT
	obj_flags = OBJ_FLAG_ANCHORABLE
	food_color = "#a34719"
	can_burn_food = TRUE
	active_power_usage = 6 KILOWATTS
	heating_power = 6000
	on_icon = "stove"
	off_icon = "stove"
	place_verb = "onto"
	resistance = 5000 // Approx. 2 minutes.
	idle_power_usage = 1 KILOWATTS
	//uses ~30% power to stay warm
	optimal_temp = T0C + 100 // can boil water!
	optimal_power = 1.2
	max_contents = 4

	starts_with = list(
		/obj/item/reagent_containers/cooking_container/skillet,
		/obj/item/reagent_containers/cooking_container/pot,
		/obj/item/reagent_containers/cooking_container/saucepan
	)

	var/list/pan_positions = list(
		list(-7, 6),
		list(-7, -3),
		list(7, 6),
		list(7, -3)
	)

/obj/machinery/appliance/cooker/stove/on_update_icon()
	..()
	ClearOverlays()
	var/list/pans = list()
	var/pan_number = 0
	for(var/obj/item/reagent_containers/cooking_container/cooking_container in contents)
		var/pan_icon_state
		var/pan_position_number = clamp((pan_number)+1, 1, 4)
		var/list/positions = pan_positions[pan_position_number]
		switch(cooking_container.appliancetype)
			if(COOKING_APPLIANCE_SKILLET)
				pan_icon_state = "skillet"
				if(pan_position_number >= 3)
					pan_icon_state = "skillet_flip"
			if(COOKING_APPLIANCE_SAUCEPAN)
				pan_icon_state = "pan"
				if(pan_position_number >= 3)
					pan_icon_state = "pan_flip"
			if(COOKING_APPLIANCE_POT)
				pan_icon_state = "pot"
			else
				continue
		var/mutable_appearance/pan_overlay = mutable_appearance('icons/obj/machines/cooking_machines.dmi', pan_icon_state)
		pan_overlay.pixel_x = positions[1]
		pan_overlay.pixel_y = positions[2]
		pan_overlay.color = cooking_container.color
		pans += pan_overlay
		pan_number = pan_position_number
		//filling
		if(cooking_container.reagents.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/machines/cooking_machines.dmi', "filling_overlay")
			filling_overlay.pixel_x = positions[1]
			filling_overlay.pixel_y = positions[2]
			filling_overlay.color = cooking_container.reagents.get_color()
			switch(cooking_container.appliancetype)
				if(COOKING_APPLIANCE_SKILLET)
					filling_overlay.pixel_y -= 3
				if(COOKING_APPLIANCE_SAUCEPAN)
					filling_overlay.pixel_y -= 2
			pans += filling_overlay
		// flame overlay
		if(operating)
			var/mutable_appearance/flame_overlay = mutable_appearance('icons/obj/machines/cooking_machines.dmi', "stove_flame")
			flame_overlay.pixel_x = positions[1]
			flame_overlay.pixel_y = positions[2]
			flame_overlay.color = "#006eff"
			pans += flame_overlay
	if(!length(pans))
		return
	AddOverlays(pans)
