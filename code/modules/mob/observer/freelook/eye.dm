// EYE
//
// A mob that another mob controls to look around the station with.
// It streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/observer/eye
	name = "Eye"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	alpha = 127

	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/owner_follows_eye = 0

	see_in_dark = 7
	invisibility = INVISIBILITY_EYE

	ghost_image_flag = GHOST_IMAGE_ALL
	var/mob/owner = null
	var/list/visibleChunks = list()

	var/datum/visualnet/visualnet

/mob/observer/eye/Move(n, direct)
	if(owner == src)
		return EyeMove(n, direct)
	return 0

/mob/observer/eye/examinate()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/observer/eye/pointed()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/observer/eye/examine(mob/user)

// Use this when setting the eye's location.
// It will also stream the chunk that the new loc is in.
/mob/observer/eye/proc/setLoc(var/T)
	if(owner)
		T = get_turf(T)
		if(T != loc)
			forceMove(T)

			if(owner.client)
				owner.client.eye = src

			if(owner_follows_eye)
				visualnet.updateVisibility(owner, 0)
				owner.forceMove(loc)
				visualnet.updateVisibility(owner, 0)

			visualnet.visibility(src)
			return 1
	return 0

/mob/observer/eye/proc/getLoc()
	if(owner)
		if(!isturf(owner.loc) || !owner.client)
			return
		return loc
/mob
	var/mob/observer/eye/eyeobj

/mob/proc/EyeMove(n, direct)
	if(!eyeobj)
		return

	return eyeobj.EyeMove(n, direct)

/mob/observer/eye/EyeMove(n, direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday)
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(src, direct))
		if(step)
			setLoc(step)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial
	return 1
