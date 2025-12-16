/client
	var/image/active_outline = null
	var/atom/active_outline_target = null

/client/proc/set_hover_outline(atom/target, accessible)
	if (active_outline)
		images -= active_outline

	active_outline = null
	active_outline_target = null

	if (!istype(target))
		return

	var/render_target_id = "outline-[any2ref(target)]"
	target.render_target = render_target_id

	active_outline = image(icon = target, loc = target)
	active_outline.appearance_flags |= RESET_COLOR | RESET_ALPHA
	active_outline_target = target

	if (accessible)
		active_outline.filters += filter(type = "outline", size = 1, color = prefs.UI_outline_accessible_color)
		active_outline.alpha = prefs.UI_outline_accessible_alpha
	else
		active_outline.filters += filter(type = "outline", size = 1, color = prefs.UI_outline_inaccessible_color)
		active_outline.alpha = prefs.UI_outline_inaccessible_alpha

	active_outline.filters += filter(type = "alpha", render_source = render_target_id, flags = MASK_INVERSE)
	active_outline.pixel_x = 0
	active_outline.pixel_y = 0
	active_outline.pixel_z = 0
	active_outline.color = null

	images += active_outline

/client/proc/clear_hover_outline(atom/target)
	if (isnull(active_outline) || isnull(target))
		return

	if (active_outline_target != target)
		return

	images -= active_outline
	active_outline = null
	active_outline_target = null

/client/Destroy()
	images -= active_outline
	active_outline = null
	return ..()
