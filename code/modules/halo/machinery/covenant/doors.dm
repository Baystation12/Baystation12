
/obj/machinery/door/airlock/covenant
	icon = 'code/modules/halo/covenant/covenantsingle/door.dmi'
	welded_file = 'code/modules/halo/covenant/covenantsingle/door.dmi'
	opacity = 0
	var/covenant_secure = 0
	fill_file = null

/obj/machinery/door/airlock/covenant/allowed(var/mob/m) //Covenant doors don't run on usual access cards. Internal tech scans the accesser.
	if(covenant_secure)
		if(m.faction == "Covenant")
			return 1
		var/mob/living/carbon/human/h = m
		if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
			return 1
		if(m & m.type in COVENANT_SPECIES_AND_MOBS)
			return 1
		return 0

	return 1
