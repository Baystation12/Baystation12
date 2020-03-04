


/* PLACEHOLDER */

/obj/machinery/overmap_comms/jammer
	name = "radio jammer"
	icon = 'code/modules/halo/comms/machines/telecomms.dmi'
	icon_state = "relay"
	desc = "Used to jam incoming radio communications."
	w_class = ITEM_SIZE_NORMAL
	active = 0
	var/list/ignore_freqs = list()
	var/jam_power = -1 // -1 = force gibberish, -2 = force garbled, any value 0+ = force gibberish, chance for garbled.
	var/jam_chance = 50
	var/jam_range = 1 //The jamming range, in tiles.
	var/jam_ignore_malfunction_chance = 0 //Chance for the jammer to jam frequencies in the ignore_freqs list.
	var/obj/effect/overmap/jamming_sector

/obj/machinery/overmap_comms/jammer/toggle_active()
	. = ..()

	to_chat(usr,"<span class = 'warning'>The [src] is now [active ? "online":"deactivated"].</span>")

	if(active)
		jamming_sector = map_sectors["[src.z]"]
		jamming_sector.telecomms_jammers.Add(src)
		GLOB.telecoms_jammers.Add(src)
	else
		if(jamming_sector)
			jamming_sector.telecomms_jammers.Remove(src)
			jamming_sector = null
		GLOB.telecoms_jammers.Remove(src)



/* OBSOLETE */

/obj/machinery/telecomms_jammers
	var/jam_power = -1 // -1 = force gibberish, -2 = force garbled, any value 0+ = force gibberish, chance for garbled.
	var/jam_chance = 50
	var/jam_range = 1 //The jamming range, in tiles.
	var/jam_ignore_malfunction_chance = 0 //Chance for the jammer to jam frequencies in the ignore_freqs list.
	var/jamming_active = 0

/obj/machinery/telecomms_jammers/unsc
	icon_state = "jammer_unsc"
	/*
	ignore_freqs = list(SHIPCOM_NAME,BERTELS_NAME,TEAMCOM_NAME,SQUADCOM_NAME,FLEETCOM_NAME,ODST_NAME,ONI_NAME)
	jam_power = 25
	jam_chance = 70
	jam_range = 40
	jam_ignore_malfunction_chance = 30
	*/

/obj/machinery/telecomms_jammers/covenant
	icon_state = "jammer_covenant"
	icon = 'code/modules/halo/comms/machines/telecomms_64.dmi'
	/*
	//ignore_freqs = list("BattleNet")
	jam_power = -2
	jam_chance = 100
	jam_range = 20
	jam_ignore_malfunction_chance = 10
	*/

/obj/machinery/telecomms_jammers/insurrectionist
	icon_state = "jammer_insurrectionist"
	/*
	jam_range = 150
	jam_chance = 50
	jam_power = -1
	jam_ignore_malfunction_chance = 0
	*/
