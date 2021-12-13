
//#define YANMEE_FLIGHT_TICKS 80

/mob/living
	var/flight_ticks_remain = 0 //Movement and life() ticks degrade this. Set by Yanme'e flight and jump-packs
	var/obj/item/flight_item/flight_item

/mob/living/Stat()
	. = ..()
	if(statpanel("Status"))
		if(flight_ticks_remain > 0)
			stat("Flight Ticks Remaining: [flight_ticks_remain]")

/mob/living/proc/decrement_flight_ticks(var/amount = 1)
	flight_ticks_remain = max(flight_ticks_remain - amount,0)
	if(flight_item && flight_item.flight_bar)
		flight_item.flight_bar.update(flight_ticks_remain)

/mob/living/Move()
	. = ..()
	if(flight_ticks_remain > 0)
		decrement_flight_ticks()

/mob/living/proc/take_flight(var/ticks_flight_apply,var/message_flight,var/message_land,var/flight_elevation = 2)
	if(elevation <= 0)
		flight_ticks_remain = ticks_flight_apply
		change_elevation(flight_elevation)
		if(message_flight)
			visible_message("[message_flight]")
	else
		Stun(2)
		flight_ticks_remain = 0
		change_elevation(-flight_elevation)
		if(message_land)
			visible_message("[message_land]")
		if(istype(loc,/turf/simulated/open))
			fall()

/*
/mob/living/carbon/human/proc/yanmee_flight_ability()
	set category = "Abilities"
	set name = "Toggle Flight"
	set desc = "Toggles your flight"

	take_flight(YANMEE_FLIGHT_TICKS,"<span class = 'warning'>[src.name] takes flight!</span>","<span class = 'warning'>[src.name] slows, then stops flapping their wings, bringing them to the ground.</span>")

#undef YANMEE_FLIGHT_TICKS
*/
