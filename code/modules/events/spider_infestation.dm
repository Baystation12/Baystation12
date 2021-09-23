/var/global/sent_spiders_to_station = 0

/datum/event/spider_infestation
	announceWhen	= 90
	var/spawncount = 1
	var/guaranteed_to_grow = 0


/datum/event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	if (severity <= EVENT_LEVEL_MODERATE)
		spawncount = 3 * severity
	else
		spawncount = 5 * severity
	guaranteed_to_grow = round(rand(spawncount / 2, spawncount / 3))
	sent_spiders_to_station = 0

/datum/event/spider_infestation/announce()
	GLOB.using_map.unidentified_lifesigns_announcement()

/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(!temp_vent.welded && temp_vent.network && (temp_vent.loc.z in affecting_z))
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		var/obj/vent = pick(vents)
		if (guaranteed_to_grow > 0)
			new /obj/effect/spider/spiderling/growing(vent.loc)
			guaranteed_to_grow--
		else
			new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--
