/datum/appearance_data
	var/list/images
	var/list/viewers

/datum/appearance_data/New(var/images, var/viewers)
	..()
	src.images = images
	src.viewers = list()
	for(var/viewer in viewers)
		AddViewer(viewer, FALSE)

/datum/appearance_data/Destroy(var/images, var/viewers)
	src.images = null
	for(var/viewer in viewers)
		RemoveViewer(viewer)
	src.viewers = null
	. = ..()

/datum/appearance_data/proc/AddViewer(var/mob/viewer, var/check_if_viewer = TRUE)
	if(check_if_viewer && (viewer in viewers))
		return FALSE
	if(!istype(viewer))
		return FALSE
	apply_images(viewer)
	logged_in_event.register(viewer, src, /datum/appearance_data/proc/apply_images)

/datum/appearance_data/proc/RemoveViewer(var/mob/viewer)
	if(!(viewer in viewers))
		return FALSE
	if(viewer.client)
		viewer.client.images -= images
	logged_in_event.unregister(viewer, src)
	return TRUE

/datum/appearance_data/proc/apply_images(var/mob/viewer)
	if(viewer.client)
		viewer.client.images |= images
