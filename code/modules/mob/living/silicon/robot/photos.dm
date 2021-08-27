/mob/living/silicon/robot/proc/photosync()
	var/obj/item/device/camera/siliconcam/master_cam = connected_ai && connected_ai.silicon_camera
	if (!master_cam)
		return

	var/synced = FALSE
	// Sync borg images to the master AI.
	// We don't care about syncing the other way around
	for(var/obj/item/photo/borg_photo in silicon_camera.aipictures)
		var/copied = FALSE
		for(var/obj/item/photo/ai_photo in master_cam.aipictures)
			if(borg_photo.id == ai_photo.id)
				copied = TRUE
				break
		if(!copied)
			master_cam.injectaialbum(borg_photo.copy(1), " (synced from [name])")
			synced = TRUE

	if(synced)
		to_chat(src, "<span class='notice'>Images synced with AI. Local images will be retained in the case of loss of connection with the AI.</span>")
