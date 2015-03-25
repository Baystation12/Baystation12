// EYE
//
// A mob that another mob controls to look around the station with.
// It streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/eye
	name = "Eye"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	alpha = 127

	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1

	see_in_dark = 7
	status_flags = GODMODE
	invisibility = INVISIBILITY_EYE

	var/mob/owner = null
	var/list/visibleChunks = list()

	var/ghostimage = null
	var/datum/visualnet/visualnet

/mob/eye/New()
	ghostimage = image(src.icon,src,src.icon_state)
	ghost_darkness_images |= ghostimage //so ghosts can see the eye when they disable darkness
	ghost_sightless_images |= ghostimage //so ghosts can see the eye when they disable ghost sight
	updateallghostimages()
	..()

mob/eye/Del()
	if (ghostimage)
		ghost_darkness_images -= ghostimage
		ghost_sightless_images -= ghostimage
		del(ghostimage)
		ghostimage = null;
		updateallghostimages()
	..()

// Movement code. Returns 0 to stop air movement from moving it.
/mob/eye/Move()
	return 0

/mob/eye/examinate()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/eye/pointed()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/eye/examine(mob/user)

// Use this when setting the eye's location.
// It will also stream the chunk that the new loc is in.
/mob/eye/proc/setLoc(var/T)
	if(owner)
		T = get_turf(T)
		loc = T

		if(owner.client)
			owner.client.eye = src

		visualnet.visibility(src)
		return 1
	return 0

/mob/eye/EyeMove(n, direct)
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

/mob/eye/proc/getLoc()
	if(owner)
		if(!isturf(owner.loc) || !owner.client)
			return
		return loc

/mob
	var/mob/eye/eyeobj

/mob/proc/EyeMove(n, direct)
	if(!eyeobj)
		return

	return eyeobj.EyeMove(n, direct)
