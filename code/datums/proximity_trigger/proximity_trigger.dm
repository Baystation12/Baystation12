/*
* Informs a given owner about objects entering relevant turfs.
* How to use:
* Supply:
*	* The atom which wish to be informed of entered turfs
*	* The proc to call when a turf has been entered. The object which entered the turf is supplied.
*		NOTE: The holder itself will call this proc if its turf changes, even if it enters a turf that isn't seen.
*	* The proc to call if the turfs being listened to have changed. The previous and new list of seen turfs is supplied.
*	* The effective range of the proximity detector. Small values strongly recommended. Can be changed later by calling set_range()
*
* Call register_turfs() to begin listening to relevant turfs.
* Call unregister_turfs() to stop listening. No argument is required.
*/

var/const/PROXIMITY_EXCLUDE_HOLDER_TURF = 1

/datum/proximity_trigger
	var/atom/holder

	var/on_turf_entered
	var/on_turfs_changed

	var/range_

	var/list/all_turfs_
	var/list/seen_turfs_

	var/proximity_flags = 0

/datum/proximity_trigger/New(var/holder, var/on_turf_entered, var/on_turfs_changed, var/range = 2, var/proximity_flags = 0)
	..()
	src.holder = holder
	src.on_turf_entered = on_turf_entered
	src.on_turfs_changed = on_turfs_changed
	range_ = range
	src.proximity_flags = proximity_flags

	all_turfs_ = list()
	seen_turfs_ = list()

/datum/proximity_trigger/Destroy()
	unregister_turfs()

	on_turfs_changed = null
	on_turf_entered = null
	holder = null
	. = ..()

/datum/proximity_trigger/proc/is_active()
	return all_turfs_.len

/datum/proximity_trigger/proc/set_range(var/new_range)
	if(range_ == new_range)
		return
	range_ = new_range
	if(is_active())
		register_turfs()

/datum/proximity_trigger/proc/register_turfs()
	moved_event.register(holder, src, /datum/proximity_trigger/proc/on_holder_moved)
	dir_set_event.register(holder, src, /datum/proximity_trigger/proc/register_turfs) // Changing direction might alter the relevant turfs

	var/list/new_turfs = acquire_relevant_turfs()
	if(listequal(all_turfs_, new_turfs))
		return

	for(var/t in (all_turfs_ - new_turfs))
		opacity_set_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_visibility_changed)
	for(var/t in (new_turfs - all_turfs_))
		opacity_set_event.register(t, src, /datum/proximity_trigger/proc/on_turf_visibility_changed)

	all_turfs_ = new_turfs
	on_turf_visibility_changed()

/datum/proximity_trigger/proc/unregister_turfs()
	moved_event.unregister(holder, src, /datum/proximity_trigger/proc/on_holder_moved)
	dir_set_event.unregister(holder, src, /datum/proximity_trigger/proc/register_turfs)

	for(var/t in all_turfs_)
		opacity_set_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_visibility_changed)
	for(var/t in seen_turfs_)
		entered_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_entered)

	call(holder, on_turfs_changed)(seen_turfs_.Copy(), list())

	all_turfs_.Cut()
	seen_turfs_.Cut()

/datum/proximity_trigger/proc/on_turf_visibility_changed()
	var/list/new_seen_turfs_ = get_seen_turfs()
	if(listequal(seen_turfs_, new_seen_turfs_))
		return

	call(holder, on_turfs_changed)(seen_turfs_.Copy(), new_seen_turfs_.Copy())

	for(var/t in (seen_turfs_ - new_seen_turfs_))
		entered_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_entered)
	for(var/t in (new_seen_turfs_ - seen_turfs_))
		entered_event.register(t, src, /datum/proximity_trigger/proc/on_turf_entered)

	seen_turfs_ = new_seen_turfs_

/datum/proximity_trigger/proc/on_holder_moved(var/holder, var/old_loc, var/new_loc)
	var/old_turf = get_turf(old_loc)
	var/new_turf = get_turf(new_loc)
	if(old_turf == new_turf)
		return
	call(holder, on_turf_entered)(holder)
	register_turfs()

/datum/proximity_trigger/proc/on_turf_entered(var/turf/T, var/atom/enterer)
	if(enterer == holder) // We have an explicit call for holder, in case it moved somewhere we're not listening to.
		return
	if(enterer.opacity)
		on_turf_visibility_changed()
	call(holder, on_turf_entered)(enterer)

/datum/proximity_trigger/proc/get_seen_turfs()
	. = list()
	var/turf/center = get_turf(holder)
	if(!center)
		return

	for(var/T in dview(range_, center))
		if(T in all_turfs_)
			. += T

/datum/proximity_trigger/proc/acquire_relevant_turfs()
	. = do_acquire_relevant_turfs()
	if(proximity_flags & PROXIMITY_EXCLUDE_HOLDER_TURF)
		. -= get_turf(holder)

/datum/proximity_trigger/proc/do_acquire_relevant_turfs()
	return list()

/obj/item/proxy_debug
	var/image/overlay

/obj/item/proxy_debug/New()
	..()
	overlay = image('icons/misc/mark.dmi', icon_state = "x3")
	var/datum/proximity_trigger/square/a = new(src, /obj/item/proxy_debug/proc/entered, /obj/item/proxy_debug/proc/turfs)
	a.register_turfs()

/obj/item/proxy_debug/proc/entered(var/atom/A)
	visible_message("[A] entered my range!")

/obj/item/proxy_debug/proc/turfs(var/list/old_turfs, var/list/new_turfs)
	for(var/turf/T in old_turfs)
		T.overlays -= overlay
	for(var/turf/T in new_turfs)
		T.overlays += overlay
