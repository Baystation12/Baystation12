/obj/machinery/door/airlock/multi_tile/covenant
	name = "Airlock"
	icon = 'door64.dmi'
	dir = NORTH
	width = 2
	var/covenant_secure = 0

/obj/machinery/door/airlock/multi_tile/covenant/allowed(var/mob/m) //Covenant doors don't run on usual access cards. Internal tech scans the accesser.
	if(covenant_secure)
		var/mob/living/carbon/human/h = m
		if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
			return 1
		if(m.type in COVENANT_SPECIES_AND_MOBS)
			return 1
		return 0

	return 1

/obj/machinery/door/airlock/multi_tile/covenant/eastwest
	icon = 'door64ew.dmi'
	dir = EAST
	width = 2



/obj/machinery/door/airlock/multi_tile/covenant/three
	name = "Airlock"
	icon = 'door96.dmi'
	dir = NORTH
	width = 3


/obj/machinery/door/airlock/multi_tile/covenant/three/eastwest
	icon = 'door96ew.dmi'
	dir = EAST
	width = 3


/obj/machinery/door/airlock/multi_tile/covenant/four
	name = "Vehicle Airlock"
	icon = 'door128.dmi'
	dir = NORTH
	width = 4


/obj/machinery/door/airlock/multi_tile/covenant/four/eastwest
	icon = 'door128ew.dmi'
	dir = EAST
	width = 4

