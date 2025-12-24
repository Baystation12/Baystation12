/**
* When atom is null, immediately clears the client's hover outline.
* Otherwise, changes the next outline source and queues an update if
* one is not already queued.
*/
/client/proc/SetOutlineAtom(atom/atom)
	if (!atom)
		if (atom_outline)
			images -= atom_outline
			atom_outline = null
		outline_atom = null
		return
	outline_atom = weakref(atom)
	if (outline_updating)
		return
	outline_updating = TRUE
	addtimer(new Callback(src, PROC_REF(UpdateOutline)), 0)

/**
* Updates the client's hover outline to the most recent source if it
* still exists, or otherwise clears the outline. Should not be called
* directly - use SetOutlineAtom.
*/
/client/proc/UpdateOutline()
	outline_updating = FALSE
	if (atom_outline)
		images -= atom_outline
		atom_outline = null
	var/atom/atom = outline_atom?.resolve()
	if (!isloc(atom))
		outline_atom = null
		return
	if (!mob)
		return
	atom_outline = image(atom, atom)
	atom_outline.pixel_x = 0
	atom_outline.pixel_y = 0
	atom_outline.pixel_z = 0
	atom_outline.alpha = prefs.outline_alpha
	atom_outline.color = null
	atom_outline.appearance_flags |= RESET_COLOR | RESET_ALPHA | NO_CLIENT_COLOR
	var/outline_color = prefs.outline_unreachable
	if (!mob.incapacitated() && mob.Adjacent(atom))
		outline_color = prefs.outline_reachable
	atom_outline.filters += filter(
		type = "outline",
		size = 1,
		color = outline_color
	)
	atom.render_target = "slate-\ref[atom]"
	atom_outline.filters += filter(
		type = "alpha",
		render_source = atom.render_target,
		flags = MASK_INVERSE
	)
	images += atom_outline
