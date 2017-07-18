/var/global/sent_spiders_to_station = 0

/datum/event/spider_infestation
	announceWhen	= 90
	var/spawncount = 1


/datum/event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	spawncount = rand(4 * severity, 6 * severity)	//spiderlings only have a 50% chance to grow big and strong
	sent_spiders_to_station = 0

/datum/event/spider_infestation/announce()
	using_map.unidentified_lifesigns_announcement()

/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in using_map.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--
