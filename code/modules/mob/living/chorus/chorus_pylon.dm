/mob/living/chorus
	var/image/pylon_image
	var/obj/structure/chorus/pylon/pylon

/mob/living/chorus/set_form(var/type)
	..()
	pylon_image = image('icons/mob/mob.dmi', icon_state = form.possession_state)
	pylon_image.alpha = 180

/mob/living/chorus/proc/possess_pylon(var/obj/structure/chorus/pylon/P)
	if(pylon)
		leave_pylon()
	pylon = P
	pylon.underlays += pylon_image
	playsound(pylon,'sound/effects/phasein.ogg',40,1)

/mob/living/chorus/proc/leave_pylon()
	if(!pylon)
		return
	pylon.underlays -= pylon_image
	pylon = null