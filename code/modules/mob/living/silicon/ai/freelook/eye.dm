// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/aiEye
	name = "Inactive AI Eye"
	icon = 'icons/mob/AI.dmi'
	icon_state = "eye"
	alpha = 127
	var/list/visibleCameraChunks = list()
	var/mob/living/silicon/ai/ai = null
	density = 0
	status_flags = GODMODE  // You can't damage it.
	see_in_dark = 7
	invisibility = INVISIBILITY_AI_EYE

// Movement code. Returns 0 to stop air movement from moving it.
/mob/aiEye/Move()
	return 0

/mob/aiEye/examinate(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/aiEye/pointed(atom/A as mob|obj|turf in view())
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/aiEye/examine(mob/user)

// Use this when setting the aiEye's location.
// It will also stream the chunk that the new loc is in.
/mob/aiEye/proc/setLoc(var/T, var/cancel_tracking = 1)

	if(ai)
		if(!isturf(ai.loc))
			return

		if(cancel_tracking)
			ai.ai_cancel_tracking()

		T = get_turf(T)
		loc = T
		cameranet.visibility(src)
		if(ai.client)
			ai.client.eye = src
		//Holopad
		if(ai.holo)
			ai.holo.move_hologram(ai)

/mob/aiEye/proc/getLoc()

	if(ai)
		if(!isturf(ai.loc) || !ai.client)
			return
		return ai.eyeobj.loc

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/mob/aiEye/eyeobj = new()
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/obj/machinery/hologram/holopad/holo = null

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	eyeobj.ai = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	spawn(5)
		eyeobj.loc = src.loc

/mob/living/silicon/ai/Del()
	eyeobj.ai = null
	del(eyeobj) // No AI, no Eye
	..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.eyeobj.setLoc(src)

// This will move the AIEye. It will also cause lights near the eye to light up, if toggled.
// This is handled in the proc below this one.

/client/proc/AIMove(n, direct, var/mob/living/silicon/ai/user)

	var/initial = initial(user.sprint)
	var/max_sprint = 50

	if(user.cooldown && user.cooldown < world.timeofday) // 3 seconds
		user.sprint = initial

	for(var/i = 0; i < max(user.sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(user.eyeobj, direct))
		if(step)
			user.eyeobj.setLoc(step)

	user.cooldown = world.timeofday + 5
	if(user.acceleration)
		user.sprint = min(user.sprint + 0.5, max_sprint)
	else
		user.sprint = initial

	//user.unset_machine() //Uncomment this if it causes problems.
	//user.lightNearbyCamera()


// Return to the Core.

/mob/living/silicon/ai/proc/core()
	set category = "AI Commands"
	set name = "AI Core"

	view_core()


/mob/living/silicon/ai/proc/view_core()
	camera = null
	unset_machine()

	if(!src.eyeobj)
		src << "ERROR: Eyeobj not found. Creating new eye..."
		src.eyeobj = new(src.loc)
		src.eyeobj.ai = src
		src.SetName(src.name)

	if(client && client.eye)
		client.eye = src
	for(var/datum/camerachunk/c in eyeobj.visibleCameraChunks)
		c.remove(eyeobj)
	src.eyeobj.setLoc(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "AI Commands"
	set name = "Toggle Camera Acceleration"

	acceleration = !acceleration
	usr << "Camera acceleration has been toggled [acceleration ? "on" : "off"]."
