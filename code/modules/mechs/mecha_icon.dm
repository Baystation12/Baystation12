proc/get_mech_image(var/cache_key, var/cache_icon, var/image_colour)
	var/use_key = "[cache_key]-[cache_icon]"
	if(image_colour) use_key += "-[image_colour]"
	if(!GLOB.mecha_image_cache[use_key])
		var/image/I = image(icon = cache_icon, icon_state = cache_key)
		if(image_colour) I.color = image_colour
		GLOB.mecha_image_cache[use_key] = I
	return GLOB.mecha_image_cache[use_key]

proc/get_mech_icon(var/obj/item/arms, var/obj/item/legs, var/obj/item/head, var/obj/item/body)
	var/list/all_images = list()
	if(head) all_images += get_mech_image(head.icon_state, head.icon, head.color)
	if(body) all_images += get_mech_image(body.icon_state, body.icon, body.color)
	if(legs) all_images += get_mech_image(legs.icon_state, legs.icon, legs.color)
	if(arms) all_images += get_mech_image(arms.icon_state, arms.icon, arms.color)
	return all_images

/mob/living/heavy_vehicle/update_icon(var/update_hardpoints = 1)

	overlays -= body_overlays
	// Get the general images.
	body_overlays = get_mech_icon(null, legs, head, body) //Arms are layered over the rest.

	// Generate and apply the decal to the main mech body.
	if(decal)

		// This needs masking so time to use gross icon procs.
		var/decal_key = "decal-[decal]-[arms.icon_state]-[legs.icon_state]-[body.icon_state]-[head.icon_state]"
		if(!GLOB.mecha_icon_cache[decal_key])
			var/template_key = "template-[arms.icon_state]-[legs.icon_state]-[body.icon_state]-[head.icon_state]"
			if(!GLOB.mecha_icon_cache[template_key])
				// Create a mask template.
				var/icon/template = icon(icon, "[body.icon_state]_mask")
				for(var/obj/item/thing in list(arms, legs, head))
					if(!thing) continue
					template.Blend(icon(thing.icon,"[thing.icon_state]_mask"),ICON_OVERLAY)
				GLOB.mecha_icon_cache[template_key] = template

			var/icon/decal_icon = icon('icons/mecha/mecha_decals.dmi',decal)
			decal_icon.Blend(GLOB.mecha_icon_cache[template_key], ICON_MULTIPLY)
			GLOB.mecha_icon_cache[decal_key] = decal_icon
		body_overlays += GLOB.mecha_icon_cache[decal_key]

	if(!hatch_closed)
		body_overlays += get_mech_image("[body.icon_state]_cockpit", body.icon)

	if(body.open_cabin)

		if(draw_pilot)
			body_overlays += draw_pilot

		body_overlays += get_mech_image("[body.icon_state][hatch_closed ? "" : "_open"]_overlay", body.icon, body.color)

		// Generate and apply the decal again (for the cockpit).
		if(decal)
			var/cabin_state = "[body.icon_state][hatch_closed ? "" : "_open"]_overlay"
			var/decal_key = "decal-[decal]-[cabin_state]"
			if(!GLOB.mecha_icon_cache[decal_key])
				var/template_key = "template-[cabin_state]"
				if(!GLOB.mecha_icon_cache[template_key])
					var/icon/template = icon(body.icon, "[cabin_state]_mask")
					GLOB.mecha_icon_cache[template_key] = template
				var/icon/decal_icon = icon('icons/mecha/mecha_decals.dmi', decal)
				decal_icon.Blend(GLOB.mecha_icon_cache[template_key], ICON_MULTIPLY)
				GLOB.mecha_icon_cache[decal_key] = decal_icon
			body_overlays += GLOB.mecha_icon_cache[decal_key]

	// Overlay the arms over everything else.
	body_overlays += get_mech_image(arms.icon_state, arms.icon, arms.color)

	// Generate and apply the decal one last time (for the arms only).
	if(decal)
		var/decal_key = "decal-[decal]-[arms.icon_state]"
		if(!GLOB.mecha_icon_cache[decal_key])
			var/template_key = "template-[arms.icon_state]"
			if(!GLOB.mecha_icon_cache[template_key])
				var/icon/template = icon(arms.icon, "[arms.icon_state]_mask")
				GLOB.mecha_icon_cache[template_key] = template
			var/icon/decal_icon = icon('icons/mecha/mecha_decals.dmi', decal)
			decal_icon.Blend(GLOB.mecha_icon_cache[template_key], ICON_MULTIPLY)
			GLOB.mecha_icon_cache[decal_key] = decal_icon
		body_overlays += GLOB.mecha_icon_cache[decal_key]

	overlays += body_overlays
	if(update_hardpoints) update_hardpoint_overlays()

/mob/living/heavy_vehicle/proc/update_hardpoint_overlays()
	overlays -= hardpoint_overlays
	hardpoint_overlays.Cut()
	for(var/hardpoint in hardpoints)
		var/obj/item/hardpoint_object = hardpoints[hardpoint]
		if(!hardpoint_object) continue
		var/use_icon_state = "[hardpoint_object.icon_state]_[hardpoint]"
		if(use_icon_state in GLOB.mecha_weapon_overlays)
			hardpoint_overlays += get_mech_image(use_icon_state, 'icons/mecha/mecha_weapon_overlays.dmi')
	overlays += hardpoint_overlays

/mob/living/heavy_vehicle/proc/update_pilot_overlay()
	overlays -= draw_pilot
	draw_pilot = image(null)
	draw_pilot.appearance = pilot
	draw_pilot.layer = layer
	draw_pilot.pixel_x += body.pilot_offset_x
	draw_pilot.pixel_y += body.pilot_offset_y
