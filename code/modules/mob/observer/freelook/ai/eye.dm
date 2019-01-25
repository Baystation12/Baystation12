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
	var/list/camera_list = list()
	var/last_loc

/mob/observer/eye/aiEye/New()
	..()
	visualnet = cameranet

/mob/observer/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	. = ..()
	if(last_loc != loc)
		last_loc = loc
		process_camera_proximity()
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

/mob/observer/eye/aiEye/proc/add_camera(var/obj/machinery/camera/C)	
	LAZYDISTINCTADD(camera_list, C)

/mob/observer/eye/aiEye/proc/remove_camera(var/obj/machinery/camera/C)
	LAZYREMOVE(camera_list, C)

/mob/observer/eye/aiEye/proc/process_camera_proximity()
	ai_near_camera(src)
	for(var/obj/machinery/camera/C in camera_list)
		if(get_dist(src, C) > 8)
			remove_camera(C)
			C.ai_stop_watching()

/mob/observer/eye/aiEye/EyeMove(direct)
	process_camera_proximity()
	. = ..()

/mob/observer/eye/aiEye/purge_cameras()
	if(camera_list)
		for(var/obj/machinery/camera/C in camera_list)
			remove_camera(C)
			C.ai_stop_watching()

/proc/ai_near_camera(var/mob/observer/eye/aiEye/eye)
	for(var/obj/machinery/camera/C in range(8, eye))
		if(C.can_use())
			C.set_ai_watching(eye)
			eye.add_camera(C)
	return

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/obj/machinery/hologram/holopad/holo = null

/mob/living/silicon/ai/proc/destroy_eyeobj(var/atom/new_eye)
	eyeobj.purge_cameras()
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
