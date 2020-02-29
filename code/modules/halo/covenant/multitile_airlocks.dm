/obj/machinery/door/airlock/multi_tile/covenant
	name = "Airlock"
	icon = 'code/modules/halo/covenant/covenantmulti/door.dmi'
	welded_file = null
	lights_file = null
	fill_file = null
	width = 2
	var/covenant_secure = 0
	maxhealth = 1200
	opacity = 0

/obj/machinery/door/airlock/multi_tile/covenant/allowed(var/mob/m) //Covenant doors don't run on usual access cards. Internal tech scans the accesser.
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

/obj/machinery/door/airlock/multi_tile/covenant/three
	name = "Airlock"
	icon = 'code/modules/halo/covenant/covenant3/door96.dmi'
	width = 3
	maxhealth = 1500

/obj/machinery/door/airlock/multi_tile/covenant/four
	name = "Vehicle Airlock"
	icon = 'code/modules/halo/covenant/covenant4/door128.dmi'
	width = 4
	maxhealth = 2000
