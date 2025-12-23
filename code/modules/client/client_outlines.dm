/client
	var/image/active_outline = null
	var/weakref/active_outline_target = null
	var/active_outline_timer_id = null

/client/proc/set_hover_outline(atom/target, accessible)
	if (!isnull(active_outline_target) && !isnull(active_outline_target.resolve()) && !isnull(target) && active_outline_target.resolve() == target)
		return

	if (active_outline)
		images -= active_outline

	if (!isnull(active_outline_timer_id))
		deltimer(active_outline_timer_id)
		active_outline_timer_id = null

	active_outline = null
	active_outline_target = null

	if (!istype(target))
		return

	active_outline_target = weakref(target)

	if (prefs.UI_outline_fast)
		commit_hover_outline(weakref(target), accessible)
	else
		var/datum/callback/active_outline_callback = new Callback(src, TYPE_PROC_REF(/client, commit_hover_outline), weakref(target), accessible)
		active_outline_timer_id = addtimer(active_outline_callback, 0.7 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE) // funny magic delay taken from Qt if anyone cares

/client/proc/commit_hover_outline(weakref/target_weakref, accessible)
	var/atom/target = target_weakref.resolve()

	active_outline_timer_id = null
	if (!istype(target))
		return

	if (active_outline)
		images -= active_outline

	var/render_target_id = "outline-[any2ref(target)]"
	target.render_target = render_target_id

	active_outline = image(icon = target, loc = target)
	active_outline.appearance_flags |= RESET_COLOR | RESET_ALPHA

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
	if (isnull(active_outline_target) || isnull(active_outline_target.resolve()) || isnull(target))
		return

	if (active_outline_target.resolve() != target)
		return	

	if (!isnull(active_outline_timer_id))
		deltimer(active_outline_timer_id)
		active_outline_timer_id = null

	images -= active_outline
	active_outline = null
	active_outline_target = null

/client/Destroy()
	images -= active_outline
	active_outline = null
	return ..()
