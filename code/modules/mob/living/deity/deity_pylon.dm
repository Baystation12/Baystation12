/mob/living/deity
	var/image/pylon_image
	var/obj/structure/deity/pylon/pylon

/mob/living/deity/set_form(var/type)
	..()
	pylon_image = image('icons/mob/mob.dmi', icon_state = form.pylon_icon_state)
	pylon_image.alpha = 180

/mob/living/deity/proc/possess_pylon(var/obj/structure/deity/pylon/P)
	if(pylon)
		leave_pylon()
	pylon = P
	pylon.overlays += pylon_image
	playsound(pylon,'sound/effects/phasein.ogg',40,1)

/mob/living/deity/proc/leave_pylon()
	if(!pylon)
		return
	pylon.overlays -= pylon_image
	pylon = null