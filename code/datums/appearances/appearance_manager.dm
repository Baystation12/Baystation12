var/global/decl/appearance_manager/appearance_manager = new()

/decl/appearance_manager
	var/list/appearances_
	var/list/appearance_handlers_

/decl/appearance_manager/New()
	..()
	appearances_ = list()
	appearance_handlers_ = list()
	for(var/entry in subtypesof(/decl/appearance_handler))
		appearance_handlers_[entry] += new entry()

/decl/appearance_manager/proc/get_appearance_handler(var/handler_type)
	return appearance_handlers_[handler_type]

/decl/appearance_manager/proc/add_appearance(var/mob/viewer, var/datum/appearance_data/ad)
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		pq = new/PriorityQueue(/proc/cmp_appearance_data)
		appearances_[viewer] = pq
		GLOB.logged_in_event.register(viewer, src, /decl/appearance_manager/proc/apply_appearance_images)
		GLOB.destroyed_event.register(viewer, src, /decl/appearance_manager/proc/remove_appearances)
	pq.Enqueue(ad)
	reset_appearance_images(viewer)

/decl/appearance_manager/proc/remove_appearance(var/mob/viewer, var/datum/appearance_data/ad, var/refresh_images)
	var/PriorityQueue/pq = appearances_[viewer]
	pq.Remove(ad)
	if(viewer.client)
		viewer.client.images -= ad.images
	if(!pq.Length())
		GLOB.logged_in_event.unregister(viewer, src, /decl/appearance_manager/proc/apply_appearance_images)
		GLOB.destroyed_event.register(viewer, src, /decl/appearance_manager/proc/remove_appearances)
		appearances_ -= viewer

/decl/appearance_manager/proc/remove_appearances(var/mob/viewer)
	var/PriorityQueue/pq = appearances_[viewer]
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		ad.RemoveViewer(viewer, FALSE)
	appearances_[viewer] -= viewer

/decl/appearance_manager/proc/reset_appearance_images(var/mob/viewer)
	clear_appearance_images(viewer)
	apply_appearance_images(viewer)

/decl/appearance_manager/proc/clear_appearance_images(var/mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images -= ad.images

/decl/appearance_manager/proc/apply_appearance_images(var/mob/viewer)
	if(!viewer.client)
		return
	var/PriorityQueue/pq = appearances_[viewer]
	if(!pq)
		return
	for(var/entry in pq.L)
		var/datum/appearance_data/ad = entry
		viewer.client.images |= ad.images
