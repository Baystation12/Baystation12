var/global/singleton/appearance_manager/appearance_manager = new()

/singleton/appearance_manager
	var/list/appearances_
	var/list/appearance_handlers_

/singleton/appearance_manager/New()
	..()
	appearances_ = list()
	appearance_handlers_ = list()
	for(var/entry in subtypesof(/singleton/appearance_handler))
		appearance_handlers_[entry] += new entry()

/singleton/appearance_manager/proc/get_appearance_handler(handler_type)
	return appearance_handlers_[handler_type]

/singleton/appearance_manager/proc/add_appearance(mob/viewer, datum/appearance_data/ad)
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		pq = new/PriorityQueue(GLOBAL_PROC_REF(cmp_appearance_data))
		appearances_[viewer] = pq
		GLOB.logged_in_event.register(viewer, src, TYPE_PROC_REF(/singleton/appearance_manager, apply_appearance_images))
		GLOB.destroyed_event.register(viewer, src, TYPE_PROC_REF(/singleton/appearance_manager, remove_appearances))
	pq.Enqueue(ad)
	reset_appearance_images(viewer)

/singleton/appearance_manager/proc/remove_appearance(mob/viewer, datum/appearance_data/ad, refresh_images)
	var/PriorityQueue/pq = appearances_[viewer]
	pq.Remove(ad)
	if(viewer.client)
		viewer.client.images -= ad.images
	if(!pq.Length())
		GLOB.logged_in_event.unregister(viewer, src, TYPE_PROC_REF(/singleton/appearance_manager, apply_appearance_images))
		GLOB.destroyed_event.register(viewer, src, TYPE_PROC_REF(/singleton/appearance_manager, remove_appearances))
		appearances_ -= viewer

/singleton/appearance_manager/proc/remove_appearances(mob/viewer)
	var/PriorityQueue/pq = appearances_[viewer]
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		ad.RemoveViewer(viewer, FALSE)
	appearances_[viewer] -= viewer

/singleton/appearance_manager/proc/reset_appearance_images(mob/viewer)
	clear_appearance_images(viewer)
	apply_appearance_images(viewer)

/singleton/appearance_manager/proc/clear_appearance_images(mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images -= ad.images

/singleton/appearance_manager/proc/apply_appearance_images(mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images |= ad.images
