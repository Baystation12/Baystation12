var/global/sent_spiders_to_station = 0

/datum/event/spider_infestation
	announceWhen	= 90
	var/spawncount = 1
	var/guaranteed_to_grow = 0


/datum/event/spider_infestation/setup()
	var/list/active_with_role = number_active_with_role()
	announceWhen = rand(announceWhen, announceWhen + 60)
	if (severity <= EVENT_LEVEL_MODERATE)
		spawncount = 3 * severity
	else
		spawncount = 5 * severity
	spawncount = min(spawncount, round(active_with_role["Any"] / 2))
	guaranteed_to_grow = max(round(rand(spawncount / 3, spawncount / 2)), severity <= EVENT_LEVEL_MODERATE ? 3 : 5)
	sent_spiders_to_station = TRUE

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
		var/obj/item/spider
		if (guaranteed_to_grow > 0)
			spider = new /obj/item/spider/giant (vent.loc)
			guaranteed_to_grow--
		else if (prob(20))
			spider = new /obj/item/spider/giant (vent.loc)
		else
			spider = new /obj/item/spider (vent.loc)
		spider.MakeActive(60)
		vents -= vent
		spawncount--
