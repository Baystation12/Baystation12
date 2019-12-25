//Refreshes the icon and sets the luminosity
/obj/machinery/portable_atmospherics/hydroponics/on_update_icon()
	// Update name.
	if(seed)
		if(mechanical)
			name = "[base_name] ([seed.seed_name])"
		else
			name = "[seed.seed_name]"
	else
		SetName(initial(name))

	overlays.Cut()
	var/new_overlays = list()
	// Updates the plant overlay.
	if(seed)
		if(dead)
			var/ikey = "[seed.get_trait(TRAIT_PLANT_ICON)]-dead"
			var/image/dead_overlay = SSplants.plant_icon_cache["[ikey]"]
			if(!dead_overlay)
				dead_overlay = image('icons/obj/hydroponics_growing.dmi', "[ikey]")
				dead_overlay.color = DEAD_PLANT_COLOUR
			new_overlays |= dead_overlay
		else
			if(!seed.growth_stages)
				seed.update_growth_stages()
			if(!seed.growth_stages)
				log_error("<span class='danger'>Seed type [seed.get_trait(TRAIT_PLANT_ICON)] cannot find a growth stage value.</span>")
				return
			var/overlay_stage = get_overlay_stage()

			var/ikey = "\ref[seed]-plant-[overlay_stage]"
			if(!SSplants.plant_icon_cache[ikey])
				SSplants.plant_icon_cache[ikey] = seed.get_icon(overlay_stage)
			new_overlays |= SSplants.plant_icon_cache[ikey]

			if(harvest && overlay_stage == seed.growth_stages)
				ikey = "[seed.get_trait(TRAIT_PRODUCT_ICON)]"
				var/image/harvest_overlay = SSplants.plant_icon_cache["product-[ikey]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"]
				if(!harvest_overlay)
					harvest_overlay = image('icons/obj/hydroponics_products.dmi', "[ikey]")
					harvest_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
					SSplants.plant_icon_cache["product-[ikey]-[harvest_overlay.color]"] = harvest_overlay
				new_overlays |= harvest_overlay

	//Updated the various alert icons.
	if(mechanical)
		//Draw the cover.
		if(closed_system)
			new_overlays += "hydrocover2"
		if(seed && plant_health <= (seed.get_trait(TRAIT_ENDURANCE) / 2))
			new_overlays += "over_lowhealth3"
		if(waterlevel <= 10)
			new_overlays += "over_lowwater3"
		if(nutrilevel <= 2)
			new_overlays += "over_lownutri3"
		if(weedlevel >= 5 || pestlevel >= 5 || toxins >= 40)
			new_overlays += "over_alert3"
		if(harvest)
			new_overlays += "over_harvest3"

	if((!density || !opacity) && seed && seed.get_trait(TRAIT_LARGE))
		if(!mechanical)
			set_density(1)
		set_opacity(1)
	else
		if(!mechanical)
			set_density(0)
		set_opacity(0)

	overlays |= new_overlays

	// Update bioluminescence.
	if(seed && seed.get_trait(TRAIT_BIOLUM))
		set_light(0.5, 0.1, 3, l_color = seed.get_trait(TRAIT_BIOLUM_COLOUR))
	else
		set_light(0)

/obj/machinery/portable_atmospherics/hydroponics/proc/get_overlay_stage()
	. = 1
	var/seed_maturation = seed.get_trait(TRAIT_MATURATION)
	if(age >= seed_maturation)
		. = seed.growth_stages
	else
		var/maturation = max(seed_maturation/seed.growth_stages, 1)
		. = max(1, round(age/maturation))