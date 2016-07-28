/datum
	var/weakref

/datum/Destroy()
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.
	. = ..()

//obtain a weak reference to a datum
/proc/weakref(datum/D)
	if(D.gcDestroyed)
		return
	if(!D.weakref)
		D.weakref = new /datum/weakref(D)
	return D.weakref

/datum/weakref
	var/reference

/datum/weakref/New(datum/D)
	reference = "\ref[D]"

/datum/weakref/Destroy()
	// A weakref datum should not be manually destroyed as it is a shared resource,
	//  rather it should be automatically collected by the BYOND GC when all references are gone.
	return 0

/datum/weakref/proc/resolve()
	var/datum/D = locate(reference)
	if(D && D.weakref == src)
		return D
	return null
