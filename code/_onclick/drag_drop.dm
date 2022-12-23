/*
* Called when this atom is drag-dropped onto over_atom with the mouse.
* atom/ typing of params is convenience-only; refer to https://www.byond.com/docs/ref/#/atom/proc/MouseDrop
*/
/atom/MouseDrop(atom/over_atom, atom/source_loc, atom/over_loc, source_control, over_control, list/mouse_params)
	if (!usr)
		return
	if (!over_atom)
		return
	if (!Adjacent(usr) || !over_atom.Adjacent(usr))
		return
	over_atom.MouseDrop_T(src, usr)


/**
 * Called by `MouseDrop()` after adjacency checks are performed. Generally, you should be using this for any mouse dragging operations.
 *
 * **Parameters**:
 * - `dropping` - The atom being dragged.
 * - `user` - The mob performing the mouse drag operation.
 */
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	// Mitigation for some user's mouses click+dragging for a split second when clicking on moving sprites.
	if (src == dropping && user.canClick())
		user.ClickOn(src)
		return TRUE
	if (dropping == user && isliving(user))
		var/mob/living/living = user
		if (can_climb(living))
			do_climb(living)
			return TRUE
	return FALSE


/**
 * Whether or not an atom can be dropped onto this atom. Called when a user click+drag's `src` onto `over`.
 *
 * **Parameters**:
 * - `over` - The atom that `src` was dropped onto.
 * - `user` - The mob click+dragging `src`.
 * - `incapacitation_flags` (Bitflag - Any of `INCAPACITATION_*`) - Additional incapacitation flags that should be checked. Used to verify `user` can perform the action. Passed directly to `user.incapacitated()`.
 *
 * Returns boolean.
 */
/atom/proc/CanMouseDrop(atom/over, mob/user = usr, incapacitation_flags)
	if (!user || !over)
		return FALSE
	if (user.incapacitated(incapacitation_flags))
		return FALSE
	if (!Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dragging through windows
	return TRUE
