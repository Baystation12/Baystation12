/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/

/atom/proc/CanMouseDrop(atom/over, var/mob/user = usr, var/incapacitation_flags)
	if(!user || !over)
		return FALSE
	if(user.incapacitated(incapacitation_flags))
		return FALSE
	if(!src.Adjacent(user) || !over.Adjacent(user))
		return FALSE // should stop you from dragging through windows
	return TRUE

/atom/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return // should stop you from dragging through windows

	spawn(0)
		over.MouseDrop_T(src,usr)
	return

// Receive a mouse drop
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	// Mitigation for some user's mouses click+dragging for a split second when clicking on moving sprites.
	if (src == dropping && user.canClick())
		user.ClickOn(src)
	return
