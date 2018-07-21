var/list/stored_shock_by_ref = list()

/mob/living/proc/apply_stored_shock_to(var/mob/living/target)
	if(stored_shock_by_ref["\ref[src]"])
		target.electrocute_act(stored_shock_by_ref["\ref[src]"]*0.9, src)
		stored_shock_by_ref["\ref[src]"] = 0

/datum/species/proc/has_fine_manipulation(var/mob/living/carbon/human/H)
	return has_fine_manipulation

/datum/species/proc/toggle_stance(var/mob/living/carbon/human/H)
	if(!H.incapacitated())
		H.pulling_punches = !H.pulling_punches
		to_chat(H, "<span class='notice'>You are now [H.pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>")

/datum/species/proc/get_offset_overlay_image(var/spritesheet, var/mob_icon, var/mob_state, var/color, var/slot)

	// If we don't actually need to offset this, don't bother with any of the generation/caching.
	if(!spritesheet && equip_adjust.len && equip_adjust[slot] && LAZYLEN(equip_adjust[slot]))

		// Check the cache for previously made icons.
		var/image_key = "[mob_icon]-[mob_state]-[color]"
		if(!equip_overlays[image_key])

			var/icon/final_I = new(mob_icon, icon_state = mob_state)
			var/list/shifts = equip_adjust[slot]

			// Apply all pixel shifts for each direction.
			for(var/shift_facing in shifts)
				var/list/facing_list = shifts[shift_facing]
				var/use_dir = text2dir(shift_facing)

				var/icon/shifting = new(final_I, dir = use_dir)
				shifting.Shift(EAST, facing_list["x"])
				shifting.Shift(NORTH, facing_list["y"])
				final_I.Insert(shifting, dir = use_dir)

			equip_overlays[image_key] = overlay_image(final_I, color, flags = RESET_COLOR)
		return equip_overlays[image_key]
	return overlay_image(mob_icon, mob_state, color, RESET_COLOR)