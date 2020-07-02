
/mob/living
	var/flight_ticks_remain = 0 //Movement and life() ticks degrade this. Set by Yanme'e flight and jump-packs
	var/obj/item/flight_item/flight_item

/mob/living/Move()
	. = ..()
	if(flight_ticks_remain > 0)
		flight_ticks_remain = max(flight_ticks_remain - 1,0)

/mob/living/proc/take_flight(var/ticks_flight_apply,var/message_flight,var/message_land)
	if(elevation <= 0)
		flight_ticks_remain = ticks_flight_apply
		change_elevation(2)
		if(message_flight)
			visible_message("[message_flight]")
	else
		flight_ticks_remain = 0
		change_elevation(-2)
		if(message_land)
			visible_message("[message_land]")
		if(istype(loc,/turf/simulated/open))
			fall()

/mob/living/carbon/human/proc/yanmee_flight_ability()
	set category = "Abilities"
	set name = "Toggle Flight"
	set desc = "Toggles your flight"

	take_flight(-1,"<span class = 'danger'>[src.name] takes flight!</span>","<span class = 'danger'>[src.name] slows, then stops flapping their wings, bringing them to the ground.</span>")