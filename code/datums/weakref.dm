/datum
	var/tmp/weakref/weakref

/datum/Destroy()
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.
	. = ..()

//obtain a weak reference to a datum
/proc/weakref(datum/D)
	if(!istype(D))
		return
	if(QDELETED(D))
		return
	if(!D.weakref)
		D.weakref = new/weakref(D)
	return D.weakref

/weakref
	var/ref

	// Handy info for debugging
	var/tmp/ref_name
	var/tmp/ref_type

/weakref/New(datum/D)
	ref = "\ref[D]"
	ref_name = "[D]"
	ref_type = D.type

/weakref/Destroy()
	// A weakref datum should not be manually destroyed as it is a shared resource,
	//  rather it should be automatically collected by the BYOND GC when all references are gone.
	return QDEL_HINT_IWILLGC

/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if(D && D.weakref == src)
		return D
	return null

/weakref/get_log_info_line()
	return "[ref_name] ([ref_type]) ([ref]) (WEAKREF)"
