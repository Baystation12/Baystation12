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

	set_opacity(material.opacity >= 0.5)

	calc_rad_resistance()
	update_connections(1)
	update_icon()


/turf/simulated/wall/proc/set_material(var/material/newmaterial, var/material/newrmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	update_material()

/turf/simulated/wall/update_icon()
	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	overlays.Cut()
	var/image/I

	if(!density)
		I = image('icons/turf/wall_masks.dmi', "[material.icon_base]fwall_open")
		I.color = material.icon_colour
		overlays += I
		return

	for(var/i = 1 to 4)
		I = image('icons/turf/wall_masks.dmi', "[material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = material.icon_colour
		overlays += I

	if(reinf_material)
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[construction_stage]")
			I.color = reinf_material.icon_colour
			overlays += I
		else
			if("[reinf_material.icon_reinf]0" in icon_states('icons/turf/wall_masks.dmi'))
				// Directional icon
				for(var/i = 1 to 4)
					I = image('icons/turf/wall_masks.dmi', "[reinf_material.icon_reinf][wall_connections[i]]", dir = 1<<(i-1))
					I.color = reinf_material.icon_colour
					overlays += I
			else
				I = image('icons/turf/wall_masks.dmi', reinf_material.icon_reinf)
				I.color = reinf_material.icon_colour
				overlays += I

	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		overlays += damage_overlays[overlay]
	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/simulated/wall/proc/update_connections(propagate = 0)
	if(!material)
		return
	var/list/dirs = list()
	for(var/turf/simulated/wall/W in orange(src, 1))
		if(!W.material)
			continue
		if(propagate)
			W.update_connections()
			W.update_icon()
		if(can_join_with(W))
			dirs += get_dir(src, W)

	wall_connections = dirs_to_corner_states(dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return 1
	return 0
