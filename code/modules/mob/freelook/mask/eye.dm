// MASK EYE
//
// A mob that a cultists controls to look around the station with.
// It streams chunks as it moves around, which will show it what the cultist can and cannot see.

/mob/eye/maskEye
	name = "Eye of Nar-Sie"
	acceleration = 0
	owner_follows_eye = 1

/mob/eye/maskEye/New()
	..()
	visualnet = cultnet

/mob/living/simple_animal/shade/narsie/New()
	..()
	sanity_check_eye()

/mob/living/simple_animal/shade/narsie/Del()
	del(eyeobj)
	..()

/mob/living/simple_animal/shade/narsie/verb/center_on_self()
	set category = "Mask of Nar-Sie"
	set name = "Center on Self"

	sanity_check_eye()
	for(var/datum/chunk/c in eyeobj.visibleChunks)
		c.remove(eyeobj)
	eyeobj.setLoc(src)

/mob/living/simple_animal/shade/narsie/proc/sanity_check_eye()
	if(!eyeobj)
		eyeobj = new /mob/eye/maskEye()
		eyeobj.owner = src
		eyeobj.setLoc(src)
