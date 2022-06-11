/mob/living/silicon/ai/proc/ai_take_image()
	set name = "PHOTO: Make"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	silicon_camera.toggle_camera_mode()
	return

/mob/living/silicon/ai/proc/ai_view_images()
	set name = "PHOTO: Viem"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	silicon_camera.viewpictures()
	return
