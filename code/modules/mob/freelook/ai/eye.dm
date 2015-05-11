// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/eye/aiEye
	name = "Inactive AI Eye"
	icon_state = "AI-eye"

/mob/eye/aiEye/New()
	..()
	visualnet = cameranet

/mob/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	if(..())
		var/mob/living/silicon/ai/ai = owner
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		//Holopad
		if(ai.holo)
			ai.holo.move_hologram(ai)
		return 1

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	eyeobj = new /mob/eye/aiEye()
	var/obj/machinery/hologram/holopad/holo = null

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/New()
	..()
	eyeobj.owner = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	spawn(5)
		if(eyeobj)
			eyeobj.loc = src.loc

/mob/living/silicon/ai/Destroy()
	if(eyeobj)
		eyeobj.owner = null
		qdel(eyeobj) // No AI, no Eye
		eyeobj = null
	..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.eyeobj.setLoc(src)

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
		src.eyeobj.owner = src
		src.SetName(src.name)

	if(client && client.eye)
		client.eye = src
	for(var/datum/chunk/c in eyeobj.visibleChunks)
		c.remove(eyeobj)
	src.eyeobj.setLoc(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "AI Commands"
	set name = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	usr << "Camera acceleration has been toggled [eyeobj.acceleration ? "on" : "off"]."
