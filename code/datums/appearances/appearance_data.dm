/datum/appearance_data
	var/list/images
	var/list/viewers

/datum/appearance_data/New(var/images, var/viewers)
	..()
	src.images = images
	src.viewers = list()
	for(var/viewer in viewers)
		AddViewer(viewer, FALSE)

/datum/appearance_data/Destroy()
	for(var/viewer in viewers)
		RemoveViewer(viewer)
	src.images = null
	src.viewers = null
	. = ..()

/datum/appearance_data/proc/AddViewer(var/mob/viewer, var/check_if_viewer = TRUE)
	if(check_if_viewer && (viewer in viewers))
		return FALSE
	if(!istype(viewer))
		return FALSE
	viewers |= viewer
	logged_in_event.register(viewer, src, /datum/appearance_data/proc/apply_images)
	destroyed_event.register(viewer, src, /datum/appearance_data/proc/RemoveViewer)
	apply_images(viewer)
	return TRUE

/datum/appearance_data/proc/RemoveViewer(var/mob/viewer)
	if(!(viewer in viewers))
		return FALSE
	if(viewer.client)
		viewer.client.images -= images
	viewers -= viewer
	logged_in_event.unregister(viewer, src)
	destroyed_event.unregister(viewer, src)
	return TRUE

/datum/appearance_data/proc/apply_images(var/mob/viewer)
	if(viewer.client)
		viewer.client.images |= images
