/datum/appearance_data
	var/priority
	var/list/images
	var/list/viewers

/datum/appearance_data/New(var/images, var/viewers, var/priority)
	..()
	src.priority = priority
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
	appearance_manager.add_appearance(viewer, src)
	return TRUE

/datum/appearance_data/proc/RemoveViewer(var/mob/viewer, var/refresh_images = TRUE)
	if(!(viewer in viewers))
		return FALSE
	viewers -= viewer
	appearance_manager.remove_appearance(viewer, src, refresh_images)
	return TRUE
