
/obj/machinery/door/airlock/covenant
	icon = 'code/modules/halo/icons/machinery/covenant/doors.dmi'
	var/covenant_secure = 0

/obj/machinery/door/airlock/covenant/allowed(var/mob/m) //Covenant doors don't run on usual access cards. Internal tech scans the accesser.
	if(covenant_secure)
		var/mob/living/carbon/human/h = m
		if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
			return 1
		if(m.type in COVENANT_SPECIES_AND_MOBS)
			return 1
		return 0

	return 1
