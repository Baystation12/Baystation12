// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/observer/eye/cameranet
	name = "Inactive Camera Eye"
	name_sufix = "Camera Eye"

/mob/observer/eye/cameranet/New()
	..()
	visualnet = cameranet

/mob/observer/eye/aiEye
	name = "Inactive AI Eye"
	name_sufix = "AI Eye"
	icon_state = "AI-eye"

/mob/observer/eye/aiEye/New()
	..()
	visualnet = cameranet

/mob/observer/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	. = ..()
	if(. && isAI(owner))
		var/mob/living/silicon/ai/ai = owner
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		//Holopad
		if(ai.holo && ai.hologram_follow)
			ai.holo.move_hologram(ai)
		return 1

/mob/observer/eye/aiEye/set_dir(new_dir)
	. = ..()
	if(. && isAI(owner))
		var/mob/living/silicon/ai/ai = owner

		//Holopad
		if(ai.holo && ai.hologram_follow)
			ai.holo.set_dir_hologram(new_dir, ai)
		return 1

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/obj/machinery/hologram/holopad/holo = null

/mob/living/silicon/ai/proc/destroy_eyeobj(var/atom/new_eye)
	if(!eyeobj) return
	if(!new_eye)
		new_eye = src
	qdel(eyeobj) // No AI, no Eye
	eyeobj = null
	if(client)
		client.eye = new_eye

/mob/living/silicon/ai/proc/create_eyeobj(var/newloc)
	if(eyeobj) destroy_eyeobj()
	if(!newloc) newloc = get_turf(src)
	eyeobj = new /mob/observer/eye/aiEye(newloc)
	eyeobj.possess(src)

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	create_eyeobj()

/mob/living/silicon/ai/Destroy()
	destroy_eyeobj()
	. = ..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.eyeobj.setLoc(src)

// Return to the Core.
/mob/living/silicon/ai/proc/core()
	set category = "Silicon Commands"
	set name = "AI Core"

	view_core()

/mob/living/silicon/ai/proc/view_core()
	camera = null
	unset_machine()

	if(!src.eyeobj)
		return

	eyeobj.possess(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "Silicon Commands"
	set name = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	to_chat(usr, "Camera acceleration has been toggled [eyeobj.acceleration ? "on" : "off"].")
