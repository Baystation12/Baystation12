/mob/living/carbon/brain
	var
		obj/item/device/mmi/container = null
		timeofhostdeath = 0

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		..()

	Del()
		if(key)//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
			if(stat!=2)//If not dead.
				death(1)//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
			ghostize(1)//Ghostize checks for key so nothing else is necessary. (1) tells that it the original body will be destroyed.
		..()

	say_understands(var/other)
		if (istype(other, /mob/living/silicon/ai))
			return 1
		if (istype(other, /mob/living/silicon/decoy))
			return 1
		if (istype(other, /mob/living/silicon/pai))
			return 1
		if (istype(other, /mob/living/silicon/robot))
			return 1
		if (istype(other, /mob/living/carbon/human))
			return 1
		if (istype(other, /mob/living/carbon/metroid))
			return 1
		return ..()

	Login()
		if(!container)
			verbs += /mob/proc/ghost

	Logout()
		verbs -= /mob/proc/ghost