// The time a datum was destroyed by the GC, or null if it hasn't been
/datum/var/gcDestroyed
#define GC_COLLECTIONS_PER_RUN 300
#define GC_COLLECTION_TIMEOUT (30 SECONDS)
#define GC_FORCE_DEL_PER_RUN 30

var/datum/controller/process/garbage_collector/garbage_collector
var/list/delayed_garbage = list()

/datum/controller/process/garbage_collector
	var/garbage_collect = 1			// Whether or not to actually do work
	var/total_dels 	= 0			// number of total del()'s
	var/tick_dels 	= 0			// number of del()'s we've done this tick
	var/soft_dels	= 0
	var/hard_dels 	= 0			// number of hard dels in total
	var/list/destroyed = list() // list of refID's of things that should be garbage collected
								// refID's are associated with the time at which they time out and need to be manually del()
								// we do this so we aren't constantly locating them and preventing them from being gc'd

	var/list/logging = list()	// list of all types that have failed to GC associated with the number of times that's happened.
								// the types are stored as strings

/datum/controller/process/garbage_collector/setup()
	name = "garbage"
	schedule_interval = 5 SECONDS
	start_delay = 3

	if(!garbage_collector)
		garbage_collector = src

	for(var/garbage in delayed_garbage)
		qdel(garbage)
	delayed_garbage.Cut()
	delayed_garbage = null

#ifdef GC_FINDREF
world/loop_checks = 0
#endif

/datum/controller/process/garbage_collector/doWork()
	if(!garbage_collect)
		return

	tick_dels = 0
	var/time_to_kill = world.time - GC_COLLECTION_TIMEOUT
	var/checkRemain = GC_COLLECTIONS_PER_RUN
	var/remaining_force_dels = GC_FORCE_DEL_PER_RUN

	while(destroyed.len && --checkRemain >= 0)
		if(remaining_force_dels <= 0)
			#ifdef GC_DEBUG
			testing("GC: Reached max force dels per tick ([remaining_force_dels] remaining of [GC_FORCE_DEL_PER_RUN])")
			#endif
			break // Server's already pretty pounded, everything else can wait 2 seconds
		var/refID = destroyed[1]
		var/GCd_at_time = destroyed[refID]
		if(GCd_at_time > time_to_kill)
			#ifdef GC_DEBUG
			testing("GC: [refID] not old enough, breaking at [world.time] for [GCd_at_time - time_to_kill] deciseconds until [GCd_at_time + GC_COLLECTION_TIMEOUT]")
			#endif
			break // Everything else is newer, skip them
		var/datum/A = locate(refID)
		#ifdef GC_DEBUG
		testing("GC: [refID] old enough to test: GCd_at_time: [GCd_at_time] time_to_kill: [time_to_kill] current: [world.time]")
		#endif
		if(A && A.gcDestroyed == GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			#ifdef GC_FINDREF
			LocateReferences(A)
			#endif
			// Something's still referring to the qdel'd object.  Kill it.
			testing("GC: -- '[log_info_line(A)]' was unable to be GC'd and was deleted --")
			logging["[A.type]"]++
			del(A)

			hard_dels++
			remaining_force_dels--
		else
			#ifdef GC_DEBUG
			testing("GC: [refID] properly GC'd at [world.time] with timeout [GCd_at_time]")
			#endif
			soft_dels++
		tick_dels++
		total_dels++
		destroyed.Cut(1, 2)
		SCHECK

#undef GC_FORCE_DEL_PER_TICK
#undef GC_COLLECTION_TIMEOUT
#undef GC_COLLECTIONS_PER_TICK

/datum/controller/process/garbage_collector/proc/AddTrash(datum/A)
	if(!istype(A) || !isnull(A.gcDestroyed))
		return
	#ifdef GC_DEBUG
	testing("GC: AddTrash(\ref[A] - [A.type])")
	#endif
	A.gcDestroyed = world.time
	destroyed -= "\ref[A]" // Removing any previous references that were GC'd so that the current object will be at the end of the list.
	destroyed["\ref[A]"] = world.time

/datum/controller/process/garbage_collector/statProcess()
	..()
	stat(null, "[garbage_collect ? "On" : "Off"], [destroyed.len] queued")
	stat(null, "Dels: [total_dels], [soft_dels] soft, [hard_dels] hard, [tick_dels]  last run")


// Tests if an atom has been deleted.
/proc/deleted(atom/A)
	return !A || !isnull(A.gcDestroyed)

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(var/datum/A)
	if(!A)
		return
	if(!istype(A))
		warning("qdel() passed object of type [A.type]. qdel() can only handle /datum types.")
		crash_with("qdel() passed object of type [A.type]. qdel() can only handle /datum types.")
		del(A)
		if(garbage_collector)
			garbage_collector.total_dels++
			garbage_collector.hard_dels++
	else if(isnull(A.gcDestroyed))
		// Let our friend know they're about to get collected
		. = !A.Destroy()
		if(. && A)
			A.finalize_qdel()

/datum/proc/finalize_qdel()
	del(src)

/atom/finalize_qdel()
	if(garbage_collector)
		garbage_collector.AddTrash(src)
	else
		delayed_garbage |= src

/client/finalize_qdel()
	del(src)

/icon/finalize_qdel()
	del(src)

/image/finalize_qdel()
	del(src)

/mob/finalize_qdel()
	del(src)

/turf/finalize_qdel()
	del(src)

/area/finalize_qdel()
    del(src)

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return true if the the GC controller should allow the object to continue existing. (Useful if pooling objects.)
/datum/proc/Destroy()
	nanomanager.close_uis(src)
	tag = null
	return

#ifdef GC_FINDREF

var/list/unwrappable_lists = list("contents","verbs","overlays","underlays","screen")

// BYOND keeps a hidden reference to objects used in a verb for a few minutes
//  which often results in items deleted by Right Click->Delete not GCing properly. Thus, this proc.
/mob/verb/create_and_delete(path_text as text)
	set category = "Debug"
	set name = "Create And Delete"

	path_text = sanitize(path_text)
	if(!path_text)
		return

	var/path = text2path(path_text)
	if(!path)
		to_chat(src, "Unable to find the path [path_text]")
	var/atom/thing = new path(loc)
	qdel(thing)

/datum/controller/process/garbage_collector/proc/LocateReferences(var/atom/A)
	testing("GC: Attempting to locate references to '[log_info_line(A)]'. This is a potentially long-running operation.")
	if(istype(A))
		if(A.loc != null)
			testing("GC: '[log_info_line(A)]' is located in ''[log_info_line(A.loc)]'' instead of null")
		if(A.contents.len)
			testing("GC: '[log_info_line(A)]' has contents: [jointext(A.contents,null)]")
	var/ref_count = 0
	for(var/atom/atom)
		ref_count += LookForRefs(atom, A)
	for(var/datum/datum)	// This is strictly /datum, not subtypes.
		ref_count += LookForRefs(datum, A)
	for(var/client/client)
		ref_count += LookForRefs(client, A)
	for(var/global_var_name in _all_globals)
		var/global_var = _all_globals[global_var_name]
		if(islist(global_var))
			ref_count += LookForListRefs(global_var, A, null, global_var_name)
		else if(global_var == A)
			testing("GC: '[log_info_line(A)]' referenced by the global var [global_var_name]")
			ref_count++
	var/message = "GC: References found to '[log_info_line(A)]': [ref_count]."
	if(!ref_count)
		message += " Has likely been supplied as an 'in list' argment to a proc."
	testing(message)

/datum/controller/process/garbage_collector/proc/LookForRefs(var/datum/D, var/datum/A)
	. = 0
	for(var/var_name in D.vars)
		if(var_name == "vars")
			continue // It is a bit silly to loop over the vars list twice.
		var/variable = 	D.vars[var_name]
		if(!islist(variable))
			if(variable == A)
				testing("GC: '[log_info_line(A)]' referenced by '[log_info_line(D)]', var [var_name]")
				. += 1
		else if(islist(variable))
			if(var_name in unwrappable_lists)
				continue
			. += LookForListRefs(variable, A, D, var_name)

/datum/controller/process/garbage_collector/proc/LookForListRefs(var/list/L, var/datum/A, var/datum/D, var/list_name)
	. = 0
	for(var/element in L)
		if(!islist(element))
			if(element == A || (!isnum(element) && !(list_name in view_variables_no_assoc) && L[element] == A))
				testing("GC: '[log_info_line(A)]' referenced by [D ? "'[log_info_line(D)]'" : "global list"], list: [list_name]")
				. += 1
		else if(islist(element))
			. += LookForListRefs(element, A, D, "[element] in list \[[list_name]\]")
#endif

#ifdef GC_DEBUG
#undef GC_DEBUG
#endif

#ifdef GC_FINDREF
#undef GC_FINDREF
#endif
