/**
* When atom is null, immediately clears the client's hover outline.
* Otherwise, changes the next outline source and queues an update if
* one is not already queued.
*/
/client/proc/SetOutlineAtom(atom/atom)
	if (!atom)
		RemoveOutlineImages()
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
	RemoveOutlineImages()
	var/atom/atom = outline_atom?.resolve()
	if (!isloc(atom))
		outline_atom = null
		return
	if (!mob)
		return
	atom_outline_mask = CreateOutlineMask(atom)
	atom_outline = image(atom, atom)
	// An attached image inherits the offsets and transform of the atom, so clear the copied values.
	atom_outline.pixel_x = 0
	atom_outline.pixel_y = 0
	atom_outline.pixel_z = 0
	atom_outline.transform = null
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
	atom_outline.filters += filter(
		type = "alpha",
		render_source = atom_outline_mask.render_target,
		flags = MASK_INVERSE
	)
	images += atom_outline_mask
	images += atom_outline

/**
* Removes the client's hover outline images. Should not be called
* directly - use SetOutlineAtom.
*/
/client/proc/RemoveOutlineImages()
	if (atom_outline)
		images -= atom_outline
		atom_outline = null
	if (atom_outline_mask)
		images -= atom_outline_mask
		atom_outline_mask = null

/**
* Returns a hidden copy of atom without its transform, for use as the
* outline mask. The render target of the atom itself has the transform
* in it, and filters apply before the transform of the outline. Such a
* mask gets the transform two times and misses a rotated or scaled atom.
*/
/client/proc/CreateOutlineMask(atom/atom)
	RETURN_TYPE(/image)
	var/image/mask = image(atom, atom)
	mask.pixel_x = 0
	mask.pixel_y = 0
	mask.pixel_z = 0
	mask.transform = null
	mask.appearance_flags |= RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mask.render_target = "*outline-mask-\ref[atom]"
	return mask
