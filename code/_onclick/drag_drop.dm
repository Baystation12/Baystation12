/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/

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
	if(!user || !over)
		return FALSE
	if(user.incapacitated(incapacitation_flags))
		return FALSE
	if(!src.Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dragging through windows
	return TRUE

/atom/MouseDrop(atom/over)
	if (!usr || !over)
		return
	if (!Adjacent(usr) || !over.Adjacent(usr))
		return
	spawn(0)
		over.MouseDrop_T(src, usr)


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
	var/mob/living/living = user
	if (istype(living) && can_climb(living) && dropped == user)
		do_climb(dropped)
		return TRUE
	return FALSE
