//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container = null
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

/mob/living/carbon/brain/New()
	create_reagents(1000)
	..()

/mob/living/carbon/brain/Destroy()
	if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat!=DEAD)	//If not dead.
			death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so nothing else is necessary.
	. = ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	if (istype(other, /mob/living/silicon/ai))
		if(!(container && istype(container, /obj/item/device/mmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/silicon/pai))
		if(!(container && istype(container, /obj/item/device/mmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/silicon/robot))
		if(!(container && istype(container, /obj/item/device/mmi)))
			return 0
		else
			return 1
	if (istype(other, /mob/living/carbon/human))
		return 1
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

/mob/living/carbon/brain/UpdateLyingBuckledAndVerbStatus()
	if(istype(loc, /obj/item/device/mmi))
		use_me = 1

/mob/living/carbon/brain/isSynthetic()
	return istype(loc, /obj/item/device/mmi/digital)

/mob/living/carbon/brain/binarycheck()
	return isSynthetic()

/mob/living/carbon/brain/check_has_mouth()
	return 0

