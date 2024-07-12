/// One-way reference to a `/weakref` instance that refers to this datum, if one exists.
/datum/var/weakref/weakref

/**
 * Creates a weakref to the given input. See `/weakref`'s documentation for more information.
 */
/proc/weakref(datum/D)
	RETURN_TYPE(/weakref)
	if(!istype(D))
		return
	if(QDELETED(D))
		return
	if(istype(D, /weakref))
		return D
	if(!D.weakref)
		D.weakref = new/weakref(D)
	return D.weakref

/**
 * A weakref holds a non-owning reference to a datum.
 * The datum can be referenced again using `resolve()`.
 *
 * To figure out why this is important, you must understand how deletion in
 * BYOND works.
 *
 * Imagine a datum as a TV in a living room. When one person enters to watch
 * TV, they turn it on. Others can come into the room and watch the TV.
 * When the last person leaves the room, they turn off the TV because it's
 * no longer being used.
 *
 * A datum being deleted tells everyone who's watching the TV to stop.
 * If everyone leaves properly (AKA cleaning up their references), then the
 * last person will turn off the TV, and everything is well.
 * However, if someone is resistant (holds a hard reference after deletion),
 * then someone has to walk in, drag them away, and turn off the TV forecefully.
 * This process is very slow, and it's known as hard deletion.
 *
 * This is where weak references come in. Weak references don't count as someone
 * watching the TV. Thus, when what it's referencing is destroyed, it will
 * hopefully clean up properly, and limit hard deletions.
 *
 * A common use case for weak references is holding onto what created itself.
 * For example, if a machine wanted to know what its last user was, it might
 * create a `var/mob/living/last_user`. However, this is a strong reference to
 * the mob, and thus will force a hard deletion when that mob is deleted.
 * It is often better in this case to instead create a weakref to the user,
 * meaning this type definition becomes `var/datum/weakref/last_user`.
 *
 * A good rule of thumb is that you should hold strong references to things
 * that you *own*. For example, a dog holding a chew toy would be the owner
 * of that chew toy, and thus a `var/obj/item/chew_toy` reference is fine
 * (as long as it is cleaned up properly).
 * However, a chew toy does not own its dog, so a `var/mob/living/dog/owner`
 * might be inferior to a weakref.
 * This is also a good rule of thumb to avoid circular references, such as the
 * chew toy example. A circular reference that doesn't clean itself up properly
 * will always hard delete.
 */
/weakref
	/// String. `\ref[]` reference of the associated `/datum`.
	var/ref

	// Handy info for debugging
	/// String. `name` of the associated `/datum`.
	var/ref_name
	/// Type path (Type of `/datum`). `type` of the associated `/datum`.
	var/ref_type

/weakref/New(datum/D)
	ref = "\ref[D]"
	ref_name = "[D]"
	ref_type = D.type

/weakref/Destroy()
	// A weakref datum should not be manually destroyed as it is a shared resource,
	//  rather it should be automatically collected by the BYOND GC when all references are gone.
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_IWILLGC

/**
 * Retrieves the datum that this weakref is referencing.
 *
 * This will return `null` if the datum was deleted. This MUST be respected.
 */

/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if(D && D.weakref == src)
		return D
	return null

/weakref/get_log_info_line()
	return "[ref_name] ([ref_type]) ([ref]) (WEAKREF)"
