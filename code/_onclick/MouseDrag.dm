//If we intercept it return true else return false
/**
 * Called by `/mob/proc/OnMouseDrag()` when a mob within this atom's contents performs a mouse drag operation. Used to provide alternative handling to mouse dragging within certain atoms.
 *
 * **Parameters**:
 * - `src_object` - The atom being dragged.
 * - `over_object` - The atom under the mouse pointer.
 * - `src_location` - The turf, stat panel, grid cell, etc from where `src_object` was dragged.
 * - `over_location` - The turf, stat panel, grid cell, etc. containing the object under the mouse pointer.
 * - `src_control` - The id of the skin control the object was dragged from
 * - `over_control` - The id of the skin control the object was dragged over
 * - `params` - Click and keyboard parameters.
 * - `user` - The mob performing the mouse drag operation.
 *
 * Returns boolean. TRUE if the mouse drag operation was intercepted, FALSE otherwise.
 */
/atom/proc/RelayMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params, mob/user)
	return FALSE

/mob/proc/OnMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)
	if(istype(loc, /atom))
		var/atom/A = loc
		if(A.RelayMouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params, src))
			return

	if(over_object)
		if(!incapacitated())
			var/obj/item/gun/gun = get_active_hand()
			if(istype(gun) && gun.can_autofire())
				set_dir(get_dir(src, over_object))
				gun.Fire(get_turf(over_object), src, params, (get_dist(over_object, src) <= 1), FALSE)
