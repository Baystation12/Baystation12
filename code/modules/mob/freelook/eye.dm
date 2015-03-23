// EYE
//
// A mob that another mob controls to look around the station with.
// It streams chunks as it moves around, which will show it what the controller can and cannot see.

/mob/eye
	name = "Eye"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	alpha = 127
	var/list/visibleChunks = list()
	var/mob/living/owner = null
	density = 0
	status_flags = GODMODE  // You can't damage it.
	see_in_dark = 7
	invisibility = INVISIBILITY_EYE
	var/ghostimage = null
	var/datum/cameranet/visualnet

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

		visualnet.visibility(src)
		return 1
	return 0

/mob/eye/proc/getLoc()
	if(owner)
		if(!isturf(owner.loc) || !owner.client)
			return
		return loc
