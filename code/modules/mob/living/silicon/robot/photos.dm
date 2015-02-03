/mob/living/silicon/robot/proc/photosync()
	var/obj/item/device/camera/siliconcam/master_cam = connected_ai ? connected_ai.aiCamera : null
	if (!master_cam)
		return

	var/synced = 0
	// Sync borg images to the master AI.
	// We don't care about syncing the other way around
	for(var/obj/item/weapon/photo/borg_photo in aiCamera.aipictures)
		var/copied = 0
		for(var/obj/item/weapon/photo/ai_photo in master_cam.aipictures)
			if(borg_photo.id == ai_photo.id)
				copied = 1
				break
		if(!copied)
			master_cam.injectaialbum(borg_photo.copy(1), " (synced from [name])")
			synced = 1

	if(synced)
		src << "<span class='notice'>Images synced with AI. Local images will be retained in the case of loss of connection with the AI.</span>"
