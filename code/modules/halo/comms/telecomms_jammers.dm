/obj/machinery/telecomms_jammers
	name = "radio jammer"
	icon = 'code/modules/halo/comms/jammers.dmi'
	icon_state = "jammer_debug"
	desc = "Used to jam incoming radio communications."
	w_class = ITEM_SIZE_NORMAL
	var/jamming_active = 0
	var/list/ignore_freqs = list()
	var/jam_power = -1 // -1 = force gibberish, -2 = force garbled, any value 0+ = force gibberish, chance for garbled.
	var/jam_chance = 50
	var/jam_range = 1 //The jamming range, in tiles.
	var/jam_ignore_malfunction_chance = 0 //Chance for the jammer to jam frequencies in the ignore_freqs list.

/obj/machinery/telecomms_jammers/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[src] is [jamming_active ? "active" : "inactive"]\nA readout on [src] states:\nPower: [jam_power].\nIntercept Chance: [jam_chance].\nRange: [jam_range].</span>")

/obj/machinery/telecomms_jammers/Initialize()
	. = ..()
	telecomms_list += src
	for(var/freq_name in ignore_freqs)
		var/freq_numerical = halo_frequencies.all_frequencies[freq_name]
		ignore_freqs -= freq_name
		ignore_freqs += freq_numerical

/obj/machinery/telecomms_jammers/Destroy()
	telecomms_list -= src
	. = ..()

/obj/machinery/telecomms_jammers/verb/toggle_jamming()
	set name = "Toggle Comms Jammer"
	set src in view(1)

	if(!istype(usr,/mob/living))
		return

	jamming_active = !jamming_active
	to_chat(usr,"<span class = 'warning'>The [src] is now [jamming_active ? "online":"deactivated"].</span>")


/obj/machinery/telecomms_jammers/unsc
	icon_state = "jammer_unsc"
	ignore_freqs = list(SHIPCOM_NAME,BERTELS_NAME,TEAMCOM_NAME,SQUADCOM_NAME,FLEETCOM_NAME,ODST_NAME,ONI_NAME)
	jam_power = 25
	jam_chance = 70
	jam_range = 40
	jam_ignore_malfunction_chance = 30

/obj/machinery/telecomms_jammers/covenant
	icon_state = "jammer_covenant"
	ignore_freqs = list("BattleNet")
	jam_power = -2
	jam_chance = 100
	jam_range = 20
	jam_ignore_malfunction_chance = 10

/obj/machinery/telecomms_jammers/insurrectionist
	icon_state = "jammer_insurrectionist"
	jam_range = 150
	jam_chance = 50
	jam_power = -1
	jam_ignore_malfunction_chance = 0

/obj/machinery/telecomms_jammers/insurrectionist/Initialize()
	. = ..()
	ignore_freqs += halo_frequencies.all_frequencies[halo_frequencies.innie_channel_name]

#undef SHIPCOM_NAME
#undef TEAMCOM_NAME
#undef SQUADCOM_NAME
#undef FLEETCOM_NAME
#undef COV_COMMON_NAME
#undef EBAND_NAME
#undef CIV_NAME
#undef SEC_NAME
#undef ODST_NAME
#undef BERTELS_NAME
#undef ONI_NAME
#undef URFC_NAME
#undef SPARTAN_NAME