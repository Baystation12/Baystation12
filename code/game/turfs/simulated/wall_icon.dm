/turf/simulated/wall/proc/update_material()

	if(!material)
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL)
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance
	// Base material `explosion_resistance` is `5`, so a value of `5 `should result in a wall resist value of `1`.
	set_damage_resistance(DAMAGE_EXPLODE, explosion_resistance ? 5 / explosion_resistance : 1)

	if(reinf_material)
		SetName("reinforced [material.display_name] [material.wall_name]")
		desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		SetName("[material.display_name] [material.wall_name]")
		desc = "It seems to be a section of hull plated with [material.display_name]."

	set_opacity(material.opacity >= 0.5)

	SSradiation.resistance_cache.Remove(src)
	update_connections(1)
	update_icon()
	calculate_damage_data()

/turf/simulated/wall/proc/paint_wall(new_paint_color)
	paint_color = new_paint_color
	update_icon()

/turf/simulated/wall/proc/stripe_wall(new_paint_color)
	stripe_color = new_paint_color
	update_icon()

/turf/simulated/wall/proc/set_material(material/newmaterial, material/newrmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	update_material()

/turf/simulated/wall/on_update_icon()

	..()

	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated; note that it is always of fixed length, so we must check for membership.
		generate_overlays()

	ClearOverlays()

	var/image/I
	var/base_color = paint_color ? paint_color : material.icon_colour
	if(!density)
		I = image('icons/turf/wall_masks.dmi', "[material.wall_icon_base]fwall_open")
		I.color = base_color
		AddOverlays(I)
		return

	for(var/i = 1 to 4)
		I = image('icons/turf/wall_masks.dmi', "[material.wall_icon_base][wall_connections[i]]", dir = SHIFTL(1, i - 1))
		I.color = base_color
		AddOverlays(I)
		if(paint_color)
			I = image('icons/turf/wall_masks.dmi', "[material.wall_icon_base]_paint[wall_connections[i]]", dir = SHIFTL(1, i-1))
			I.color = paint_color
			AddOverlays(I)
		if(stripe_color)
			I = image('icons/turf/wall_masks.dmi', "[material.wall_icon_base]_stripe[wall_connections[i]]", dir = SHIFTL(1, i-1))
			I.color = stripe_color
			AddOverlays(I)

	if(reinf_material)
		var/reinf_color = paint_color ? paint_color : reinf_material.icon_colour
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[construction_stage]")
			I.color = reinf_color
			AddOverlays(I)
		else
			if("[material.wall_icon_reinf]0" in icon_states('icons/turf/wall_masks.dmi'))
				// Directional icon
				for(var/i = 1 to 4)
					I = image('icons/turf/wall_masks.dmi', "[material.wall_icon_reinf][wall_connections[i]]", dir = SHIFTL(1, i - 1))
					I.color = reinf_color
					AddOverlays(I)
			else
				I = image('icons/turf/wall_masks.dmi', material.wall_icon_reinf)
				I.color = reinf_color
				AddOverlays(I)

	if(material.wall_flags & MATERIAL_WALL_HAS_EDGES)
		for(var/i = 1 to 4)
			I = image('icons/turf/wall_masks.dmi', "[material.wall_icon_base]_other[other_connections[i]]", dir = SHIFTL(1, i-1))
			I.color = stripe_color ? stripe_color : base_color
			AddOverlays(I)

	var/image/texture = material.get_wall_texture()
	if(texture)
		AddOverlays(texture)

	if(get_damage_value() != 0)
		var/overlay = round((get_damage_percentage() / 100) * length(damage_overlays)) + 1
		overlay = clamp(overlay, 1, length(damage_overlays))

		AddOverlays(damage_overlays[overlay])
	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / length(damage_overlays)

	for(var/i = 1; i <= length(damage_overlays); i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/simulated/wall/proc/update_connections(propagate = 0)
	if(!material)
		return
	var/list/wall_dirs = list()
	var/list/other_dirs = list()

	for(var/stepdir in GLOB.alldirs)
		var/turf/T = get_step(src, stepdir)
		if(!T)
			continue
		if(istype(T, /turf/simulated/wall))
			switch(can_join_with(T))
				if(0)
					continue
				if(1)
					wall_dirs += get_dir(src, T)
				if(2)
					wall_dirs += get_dir(src, T)
					other_dirs += get_dir(src, T)
			if(propagate)
				var/turf/simulated/wall/W = T
				W.update_connections()
				W.update_icon()
		var/success = 0
		for(var/O in T)
			for(var/b_type in GLOB.wall_blend_objects)
				if(istype(O, b_type))
					success = TRUE
					break
			for(var/nb_type in GLOB.wall_noblend_objects)
				if(istype(O, nb_type))
					success = FALSE
					break
			if(success)
				wall_dirs += get_dir(src, T)
				var/blendable = FALSE
				for(var/fb_type in GLOB.wall_fullblend_objects)
					if(istype(O, fb_type))
						blendable = TRUE
						break
				if(!blendable)
					other_dirs += get_dir(src, T)
				break
		wall_connections = dirs_to_corner_states(wall_dirs)
		other_connections = dirs_to_corner_states(other_dirs)

/turf/simulated/wall/proc/can_join_with(turf/simulated/wall/W)
	if(material && istype(W.material))
		if(material.wall_blend_icons[W.material.wall_icon_base])
			return 2
		if(material.wall_icon_base == W.material.wall_icon_base)
			if(paint_color != W.paint_color)
				return 2
			return 1
	return 0
