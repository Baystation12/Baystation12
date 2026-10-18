/**
 * Gives this mob's client the mouse pointer `get_mouse_pointer()` asks for. Call it whenever something that proc looks
 * at has changed.
 *
 * Has no return value.
 */
/mob/proc/update_mouse_pointer()
	if (client)
		client.mouse_pointer_icon = get_mouse_pointer()

/**
 * The icon file this mob's client should use for its mouse pointer. See BYOND's `mouse_pointer_icon` documentation for
 * the icon states such a file may have.
 *
 * Returns an icon file, or null for the default pointers.
 */
/mob/proc/get_mouse_pointer()
	return null

/mob/living/carbon/get_mouse_pointer()
	var/obj/item/held = get_active_hand()
	return held?.get_mouse_pointer(src) || ..()

/**
 * The icon file a mob holding this item in the active hand should use for its mouse pointer.
 *
 * **Parameters**:
 * - `user` - The mob holding the item.
 *
 * Returns an icon file, or null if the item does not change the pointer.
 */
/obj/item/proc/get_mouse_pointer(mob/user)
	return null

/obj/item/gun/get_mouse_pointer(mob/user)
	// Someone who can't see the safety indicator doesn't know the safety is on, so the pointer doesn't tell them either.
	if (safety() && shows_safety_to(user))
		return null
	if (user.get_preference_value(/datum/client_preference/gun_crosshair) != GLOB.PREF_YES)
		return null
	return 'icons/obj/guns/crosshair.dmi'
