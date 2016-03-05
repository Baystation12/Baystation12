/datum
	var/weakref

/datum/Destroy()
	weakref = null // Clear this reference to ensure it's kept for as brief duration as possible.
	return ..()

//obtain a weak reference to a datum
/proc/weakref(datum/D)
	if(!D.weakref)
		D.weakref = new /datum/weakref(D)
	return D.weakref

/datum/weakref
	var/ref

/datum/weakref/New(datum/D)
	ref = "\ref[D]"

/datum/weakref/Destroy()
	// A weakref datum should not be manually destroyed as it is a shared resource,
	//  but rather be automatically collected by the BYOND GC when all references are gone.
	return 0

/datum/weakref/proc/resolve()
	var/datum/D = locate(ref)
	if(D && D.weakref == src)
		return D
	return null
