// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/eye/aiEye
	name = "Inactive AI Eye"
	icon_state = "AI-eye"
	var/mob/living/silicon/ai/ai = null

/mob/eye/aiEye/New()
	..()
	visualnet = cameranet

/mob/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	if(..())
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		if(ai.client)
			ai.client.eye = src
		//Holopad
		if(ai.holo)
			ai.holo.move_hologram(ai)
		return 1

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	var/mob/eye/aiEye/eyeobj = new()
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/obj/machinery/hologram/holopad/holo = null

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	eyeobj.ai = src
	eyeobj.owner = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	eyeobj.visualnet = cameranet
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
	for(var/datum/chunk/c in eyeobj.visibleChunks)
		c.remove(eyeobj)
	src.eyeobj.setLoc(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "AI Commands"
	set name = "Toggle Camera Acceleration"

	acceleration = !acceleration
	usr << "Camera acceleration has been toggled [acceleration ? "on" : "off"]."
