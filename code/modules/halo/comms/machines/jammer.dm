
/obj/machinery/overmap_comms/jammer
	name = "radio frequency jammer"
	icon_state = "relay_off"
	icon_state_active = "relay"
	icon_state_inactive = "relay_off"
	desc = "Used to jam incoming and outgoing radio signals."
	active = 0
	w_class = ITEM_SIZE_NORMAL
	var/list/ignore_freqs = list()
	var/jam_power = -1 // -1 = force gibberish, -2 = force garbled, any value 0+ = force gibberish, chance for garbled.
	var/jam_chance = 50
	var/jam_range = 1 //The jamming range, in tiles.
	var/jam_ignore_malfunction_chance = 0 //Chance for the jammer to jam frequencies in the ignore_freqs list.
	var/obj/effect/overmap/jamming_sector

/obj/machinery/overmap_comms/jammer/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[src] is [active ? "active" : "inactive"]\nA readout on [src] states:\nPower: [jam_power].\nIntercept Chance: [jam_chance].\nRange: [jam_range].</span>")

/obj/machinery/overmap_comms/jammer/Initialize()
	. = ..()
	/*
	for(var/freq_name in ignore_freqs)
		var/freq_numerical = halo_frequencies.all_frequencies[freq_name]
		ignore_freqs -= freq_name
		ignore_freqs += freq_numerical
		*/

/obj/machinery/overmap_comms/jammer/Destroy()
	if(jamming_sector)
		jamming_sector.telecomms_jammers.Remove(src)
	GLOB.telecoms_jammers -= src
	. = ..()

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


/obj/machinery/overmap_comms/jammer/unsc
	//ignore_freqs = list(SHIPCOM_NAME,BERTELS_NAME,TEAMCOM_NAME,SQUADCOM_NAME,FLEETCOM_NAME,ODST_NAME,ONI_NAME)
	jam_power = 25
	jam_chance = 70
	jam_range = 40
	jam_ignore_malfunction_chance = 30

/obj/machinery/overmap_comms/jammer/covenant
	icon = 'code/modules/halo/comms/machines/telecomms_64.dmi'
	icon_state = "jammer_covenant"
	icon_state_active = "jammer_covenant"
	icon_state_inactive = "jammer_covenant_off"
	ignore_freqs = list("BattleNet")
	jam_power = -2
	jam_chance = 100
	jam_range = 20
	jam_ignore_malfunction_chance = 10

/obj/machinery/overmap_comms/jammer/insurrectionist
	jam_range = 150
	jam_chance = 50
	jam_power = -1
	jam_ignore_malfunction_chance = 0

/obj/machinery/overmap_comms/jammer/insurrectionist/Initialize()
	. = ..()
	//ignore_freqs += halo_frequencies.all_frequencies[halo_frequencies.innie_channel_name]

//OLD PATH... delete these from the map
/obj/machinery/telecomms_jammers/covenant
/obj/machinery/telecomms_jammers/unsc
/obj/machinery/telecomms_jammers/insurrectionist
