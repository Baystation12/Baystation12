/turf/simulated/wall/proc/update_material()

	if(!material)
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance

	if(reinf_material)
		name = "reinforced [material.display_name] wall"
		desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		name = "[material.display_name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name]."

	set_wall_state("[material.icon_base]0")

	if(material.opacity > 0.5 && !opacity)
		set_light(1)
	else if(material.opacity < 0.5 && opacity)
		set_light(0)

	update_icon()
	check_relatives()

/turf/simulated/wall/proc/set_wall_state(var/new_state)

	if(!material)
		return

	if(new_state)
		last_state = new_state
	else if(last_state)
		new_state = last_state
	else
		return

	overlays.Cut()
	damage_overlay = 0

	if(!wall_cache["[new_state]-[material.icon_colour]"])
		var/image/I = image(icon='icons/turf/wall_masks.dmi',icon_state="[new_state]")
		I.color = material.icon_colour
		wall_cache["[new_state]-[material.icon_colour]"] = I
	overlays |= wall_cache["[new_state]-[material.icon_colour]"]
	if(reinf_material)

		var/cache_key = "[material.icon_reinf]-[reinf_material.icon_colour]"
		if(!isnull(construction_stage) && construction_stage<6)
			cache_key = "reinf_construct-[reinf_material.icon_colour]-[construction_stage]"

		if(!wall_cache[cache_key])
			var/image/I
			if(!isnull(construction_stage) && construction_stage<6)
				I = image(icon='icons/turf/wall_masks.dmi',icon_state="reinf_construct-[construction_stage]")
			else
				I = image(icon='icons/turf/wall_masks.dmi',icon_state="[material.icon_reinf]")
			I.color = reinf_material.icon_colour
			wall_cache[cache_key] = I
		overlays |= wall_cache[cache_key]

/turf/simulated/wall/proc/set_material(var/material/newmaterial, var/material/newrmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	update_material()
	check_relatives()
	check_relatives(1)

/turf/simulated/wall/proc/update_icon()
	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	if(density)
		check_relatives(1)
	else
		set_wall_state("[material.icon_base]fwall_open")

	if(damage == 0)
		if(damage_overlay != 0)
			overlays -= damage_overlays[damage_overlay]
		damage_overlay = 0
	else if(density)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		if(damage_overlay && overlay == damage_overlay) //No need to update.
			return

		if(damage_overlay) overlays -= damage_overlays[damage_overlay]
		overlays += damage_overlays[overlay]
		damage_overlay = overlay
	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

//Smoothwall code. update_self for relativewall(), not for relativewall_neighbors()
/turf/simulated/wall/proc/check_relatives(var/update_self)
	if(!material)
		return
	var/junction
	if(update_self)
		junction = 0
	for(var/checkdir in cardinal)
		var/turf/simulated/wall/T = get_step(src, checkdir)
		if(!istype(T) || !T.material)
			continue
		if(update_self)
			if(can_join_with(T))
				junction |= get_dir(src,T) //Not too sure why, but using checkdir just breaks walls.
		else
			T.check_relatives(1)
	if(!isnull(junction))
		set_wall_state("[material.icon_base][junction]")
	return

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return 1
	return 0
