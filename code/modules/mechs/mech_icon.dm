proc/get_mech_image(var/decal, var/cache_key, var/cache_icon, var/image_colour, var/overlay_layer = FLOAT_LAYER)
	var/use_key = "[cache_key]-[cache_icon]-[overlay_layer]-[decal ? decal : "none"]-[image_colour ? image_colour : "none"]"
	if(!GLOB.mech_image_cache[use_key])
		var/image/I = image(icon = cache_icon, icon_state = cache_key)
		if(image_colour)
			var/image/masked_color = image(icon = cache_icon, icon_state = "[cache_key]_mask")
			masked_color.color = image_colour
			masked_color.blend_mode = BLEND_MULTIPLY
			I.overlays += masked_color
		if(decal)
			var/decal_key = "[decal]-[cache_key]"
			if(!GLOB.mech_icon_cache[decal_key])
				var/template_key = "template-[cache_key]"
				if(!GLOB.mech_icon_cache[template_key])
					GLOB.mech_icon_cache[template_key] = icon(cache_icon, "[cache_key]_mask")
				var/icon/decal_icon = icon('icons/mecha/mech_decals.dmi',decal)
				decal_icon.AddAlphaMask(GLOB.mech_icon_cache[template_key])
				GLOB.mech_icon_cache[decal_key] = decal_icon
			var/image/decal_image = get_mech_image(null, decal_key, GLOB.mech_icon_cache[decal_key])
			decal_image.blend_mode = BLEND_MULTIPLY
			I.overlays += decal_image
		I.appearance_flags |= RESET_COLOR
		I.layer = overlay_layer
		I.plane = FLOAT_PLANE
		GLOB.mech_image_cache[use_key] = I
	return GLOB.mech_image_cache[use_key]

proc/get_mech_images(var/list/components = list(), var/overlay_layer = FLOAT_LAYER)
	var/list/all_images = list()
	for(var/obj/item/mech_component/comp in components)
		all_images += get_mech_image(comp.decal, comp.icon_state, comp.on_mech_icon, comp.color, overlay_layer)
	return all_images

/mob/living/exosuit/on_update_icon()
	var/list/new_overlays = get_mech_images(list(body, head), MECH_BASE_LAYER)
	if(body)
		new_overlays += get_mech_image(body.decal, "[body.icon_state]_cockpit", body.on_mech_icon, overlay_layer = MECH_INTERMEDIATE_LAYER)
	update_pilots(FALSE)
	if(LAZYLEN(pilot_overlays))
		new_overlays += pilot_overlays
	if(body)
		new_overlays += get_mech_image(body.decal, "[body.icon_state]_overlay[hatch_closed ? "" : "_open"]", body.on_mech_icon, body.color, MECH_COCKPIT_LAYER)
	if(arms)
		new_overlays += get_mech_image(arms.decal, arms.icon_state, arms.on_mech_icon, arms.color, MECH_ARM_LAYER)
	if(legs)
		new_overlays += get_mech_image(legs.decal, legs.icon_state, legs.on_mech_icon, legs.color, MECH_LEG_LAYER)
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_equipment/hardpoint_object = hardpoints[hardpoint]
		if(hardpoint_object)
			var/use_icon_state = "[hardpoint_object.icon_state]_[hardpoint]"
			if(use_icon_state in GLOB.mech_weapon_overlays)
				new_overlays += get_mech_image(null, use_icon_state, 'icons/mecha/mech_weapon_overlays.dmi', null, hardpoint_object.mech_layer )
	overlays = new_overlays

/mob/living/exosuit/proc/update_pilots(var/update_overlays = TRUE)
	if(update_overlays && LAZYLEN(pilot_overlays))
		overlays -= pilot_overlays
	pilot_overlays = null
	if(!body || ((body.pilot_coverage < 100 || body.transparent_cabin) && !body.hide_pilot))
		for(var/i = 1 to LAZYLEN(pilots))
			var/mob/pilot = pilots[i]
			var/image/draw_pilot = new
			draw_pilot.appearance = pilot
			var/rel_pos = dir == NORTH ? -1 : 1
			draw_pilot.layer = MECH_PILOT_LAYER + (body ? ((LAZYLEN(body.pilot_positions)-i)*0.001 * rel_pos) : 0)
			draw_pilot.plane = FLOAT_PLANE
			if(body && i <= LAZYLEN(body.pilot_positions))
				var/list/offset_values = body.pilot_positions[i]
				var/list/directional_offset_values = offset_values["[dir]"]
				draw_pilot.pixel_x = pilot.default_pixel_x + directional_offset_values["x"]
				draw_pilot.pixel_y = pilot.default_pixel_y + directional_offset_values["y"]
				draw_pilot.pixel_z = 0
				draw_pilot.transform = null
			LAZYADD(pilot_overlays, draw_pilot)
		if(update_overlays && LAZYLEN(pilot_overlays))
			overlays += pilot_overlays

/mob/living/exosuit/regenerate_icons()
	return