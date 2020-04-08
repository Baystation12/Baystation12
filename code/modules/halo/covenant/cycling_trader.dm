
/obj/effect/landmark/cycling_trader
	var/trader_visit_min = 5 MINUTES
	var/trader_visit_max = 10 MINUTES
	var/trader_gap_min = 5 MINUTES
	var/trader_gap_max = 10 MINUTES

	var/trader_visitduration = 0
	var/time_cycle_trader = 0

	var/has_trader = 0
	var/announce_channel = RADIO_HUMAN
	var/clan_name = "Hidden Clan"

/obj/effect/landmark/cycling_trader/New()
	. = ..()
	GLOB.processing_objects.Add(src)
	time_cycle_trader = world.time + trader_gap_max

/obj/effect/landmark/cycling_trader/process()
	if(world.time > time_cycle_trader)
		if(has_trader)
			trader_leave()
		else
			trader_arrive()

/obj/effect/landmark/cycling_trader/proc/trader_arrive()
	has_trader = 1
	time_cycle_trader = world.time + rand(trader_visit_min, trader_visit_max)
	GLOB.global_announcer.autosay("Trader has arrived at the [clan_name].", "Doisac Flight Control", announce_channel, "Sangheili")

/obj/effect/landmark/cycling_trader/proc/trader_leave()
	has_trader = 0
	time_cycle_trader = world.time + rand(trader_gap_min, trader_gap_max)
	GLOB.global_announcer.autosay("Trader has departed the [clan_name].", "Doisac Flight Control", announce_channel, "Sangheili")
