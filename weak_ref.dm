/datum
	var/datum/weak_reference/weak_reference	// A strong reference to a potential weak-reference datum.

/datum/weak_reference
	var/ref

/datum/weak_reference/New(var/datum/instance)
	if(instance.weak_reference)	// We only support datums because we're evil.
		CRASH("MULTIPLE WEAK-REFERENCES DETECTED")

	// Store the ref, make the instance strongly reference this weak-reference datum.
	ref = "\ref[instance]"
	instance.weak_reference = src
	..()

/datum/weak_reference/proc/get_instance()
	// locate() the instance using the ref, check that this instance is referencing us, otherwise return null
	var/datum/instance = locate(ref)
	if(instance && instance.weak_reference == src)
		return instance

/datum/weak_reference_provider
	var/weak_references

/datum/weak_reference_provider/New()
	weak_references = list()
	..()

/datum/weak_reference_provider/proc/weak_reference(var/datum/instance)
	var/datum/weak_reference/weak_instance = weak_references[instance]
	// If we already have a weak-reference datum for this instance, return it
	if(weak_instance)
		return weak_instance

	// Listening to the instance's Destroyed event, to allow us to cleanup when required.
	destroyed_event.register(src, instance, /datum/weak_reference_provider/proc/instance_destroyed)
	weak_instance =	new(instance)				// The weak-reference will handle its own setup.
	weak_references[instance] = weak_instance	// And store it for later re-use, of course.
	return weak_instance


/datum/weak_reference_provider/proc/instance_destroyed(var/datum/instance)
	// Remove all pointers to the weak-reference datum when the instance it's referencing is destroyed.
	// We deliberately don't qdel() the weak-reference datum because we don't want del() to force-clear any other usages of the weak datum.
	// Instead we hope that people drop any pointers to weak-reference datums when they find that it is no longer of use.
	instance.weak_reference = null
	weak_references -= instance
