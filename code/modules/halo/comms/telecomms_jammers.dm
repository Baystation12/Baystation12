

/obj/machinery/overmap_comms/jammer
	name = "Communications Jammer"
	desc = "Garbles radio communications. Range, power and intercept-chance varies by model."
	icon = 'code/modules/halo/comms/machines/telecomms.dmi'
	icon_state = "relay_off"
	icon_state_active = "relay"
	icon_state_inactive = "relay_off"
	w_class = ITEM_SIZE_LARGE
	active = 0
	anchored = 0
	var/list/ignore_freqs = list()
	var/jam_power = -1 // -1 = force garbled, -2 = force gibberish, any value 0+ = force garble, chance for gibberish.
	var/jam_chance = 100
	var/jam_range = -1 //-1 = whole sector, anything higher is in tile-range.
	var/jam_ignore_malfunction_chance = 0 //Chance for the jammer to jam frequencies in the ignore_freqs list.
	var/jam_time_remaining = -1 //Sets a limited timeframe, after which the jammer explodes.
	var/jam_end_at
	var/obj/effect/overmap/jamming_sector

/obj/machinery/overmap_comms/jammer/examine(var/mob/user)
	. = ..()
	to_chat(user,"<span class = 'notice'>[src] is [active ? "active" : "inactive"]\nA readout on [src] states:\nInterference Intensity: [jam_power == -2 ? "Major" : jam_power == -1 ? "Minor" : "Minor with a [jam_power]% chance of major"].\nIntercept Chance: [jam_chance].\nRange: [jam_range > 0 ? jam_range : "Sector-Wide"]</span>")
	if(jam_time_remaining > 0)
		to_chat(user,"<span class = 'notice'>[src] has a powerful internal battery, prone to dangerously overheating. Usually more powerful than a standard jammer, but overloads after a short time.</span>")

/obj/machinery/overmap_comms/jammer/toggle_active(var/mob/user)
	anchored = 0
	if(user && jam_time_remaining > 0)//Let's only use this single use function if we actually have a person doing it.
		anchored = 1
		if(!active)
			jam_end_at = world.time + jam_time_remaining
			jamming_sector = map_sectors["[src.z]"]
			jamming_sector.telecomms_jammers.Add(src)
			. = ..()
		return
	. = ..()
	if(active)
		jamming_sector = map_sectors["[src.z]"]
		jamming_sector.telecomms_jammers.Add(src)
		anchored = 1
	else if(!failure_timer)
		if(jamming_sector)
			jamming_sector.telecomms_jammers.Remove(src)
			jamming_sector = null

/obj/machinery/overmap_comms/jammer/attack_hand(var/mob/user)
	toggle_active(user)
	to_chat(user,"<span class = 'notice'>You toggle [src] to [active ? "on":"off"]</span>")

/obj/machinery/overmap_comms/jammer/Process()
	. = ..()
	if(jam_end_at && world.time > jam_end_at)
		toggle_active()
		visible_message("<span class = 'danger'>[src] begins to overheat...</span>")
		STOP_PROCESSING(SSobj, src)
		explosion(get_turf(src),-1,1,2,0)
		qdel(src)

/obj/machinery/overmap_comms/jammer/stationary
	name = "Stationary Communications Jammer"
	anchored = 1

/obj/machinery/overmap_comms/jammer/stationary/toggle_active()
	. = ..()
	anchored = 1

//Faction Jammers//

/obj/machinery/overmap_comms/jammer/unsc

	jam_power = 25
	jam_chance = 70
	jam_range = 21
	jam_ignore_malfunction_chance = 20

	ignore_freqs = list(RADIO_SQUAD,RADIO_MARINE,RADIO_ODST,RADIO_ONI,RADIO_SPARTAN,RADIO_FLEET)

/obj/machinery/overmap_comms/jammer/unsc/limited
	name = "High-Power Communications Jammer"
	jam_time_remaining = 2 MINUTES
	jam_range = -1

//This is for ONI base and should not be outside ONI base.
/obj/machinery/overmap_comms/jammer/stationary/ONI
	jam_chance = 100
	jam_power = -2
	jam_range = 45
	ignore_freqs = list(RADIO_ONI)

/obj/machinery/overmap_comms/jammer/covenant
	icon = 'code/modules/halo/comms/machines/telecomms_64.dmi'
	icon_state = "jammer_covenant"
	icon_state_active = "jammer_covenant"
	icon_state_inactive = "jammer_covenant_off"

	jam_power = -1
	jam_chance = 100
	jam_range = 16
	jam_ignore_malfunction_chance = 10

	ignore_freqs = list(RADIO_COV,RADIO_COVREQ)

/obj/machinery/overmap_comms/jammer/covenant/limited
	name = "High-Power Communications Jammer"
	jam_time_remaining = 2 MINUTES
	jam_range = -1

/obj/machinery/overmap_comms/jammer/insurrectionist

	jam_chance = 60
	jam_power = -1
	jam_range = 30
	jam_ignore_malfunction_chance = 0

	ignore_freqs = list(RADIO_INNIE,RADIO_URFC)

/obj/machinery/overmap_comms/jammer/insurrectionist/Initialize()
	. = ..()
	ignore_freqs += GLOB.INSURRECTION.get_innie_channel_name()

/obj/machinery/overmap_comms/jammer/insurrectionist/limited
	name = "High-Power Communications Jammer"
	jam_time_remaining = 3 MINUTES //Innie jammer is awful, so let's give it a bit of extra jam time.
	jam_range = -1
