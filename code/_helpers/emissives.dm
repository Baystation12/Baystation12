/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = EMPTY_BITFIELD)
	var/mutable_appearance/appearance = mutable_appearance(icon = icon, icon_state = icon_state, layer = layer, plane = EMISSIVE_PLANE, flags = appearance_flags|EMISSIVE_APPEARANCE_FLAGS)
	if(alpha == 255)
		appearance.color = GLOB.emissive_color
	else
		var/alpha_ratio = alpha/255
		appearance.color = _EMISSIVE_COLOR(alpha_ratio)
	return appearance

/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EM_BLOCK_COLOR].
/proc/emissive_blocker(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = EMPTY_BITFIELD, source = null)
	var/mutable_appearance/appearance = mutable_appearance(icon = icon, icon_state = icon_state, layer = layer, plane = EMISSIVE_PLANE, flags = appearance_flags|EMISSIVE_APPEARANCE_FLAGS)
	appearance.color = GLOB.em_block_color
	if(source)
		appearance.render_source = source
		// Since only render_target handles transform we don't get any applied transform "stacking"
		appearance.appearance_flags |= RESET_TRANSFORM
	return appearance

// Designed to be a faster version of the above, for most use-cases
/proc/fast_emissive_blocker(atom/make_blocker)
	var/mutable_appearance/blocker = new()
	blocker.icon = make_blocker.icon
	blocker.icon_state = make_blocker.icon_state
	blocker.appearance_flags |= make_blocker.appearance_flags | EMISSIVE_APPEARANCE_FLAGS
	blocker.dir = make_blocker.dir
	blocker.color = GLOB.em_block_color
	blocker.plane = EMISSIVE_PLANE
	return blocker
