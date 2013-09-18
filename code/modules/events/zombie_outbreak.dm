/datum/event/zombie_outbreak
	startWhen = 40
	announceWhen = 20
	endWhen = 800
	oneShot = 1				//DON'T SPAWN ANOTHER OUTBREAK, one is bad enough
	var/spawncount = 12		//Base zombie count

/datum/event/carp_migration/setup()
	announceWhen = rand(10, 40)
	startWhen = rand(announceWhen, 50)	//Doesn't pick anything before announcement
	endWhen = rand(600,1200)

/datum/event/zombie_outbreak/start()
	var/count = 0
	if(player_list.len < 12)
		count = 2
	else if(player_list.len < 22)
		count = 1
	else
		count = 0
	for(count, count < 3, count++)
		for(var/mob/living/carbon/F in living_mob_list)	//Has a chance to spawn zombies on players or mobs
			sleep(20)
			if(prob(40))
				var/mob/living/simple_animal/hostile/zombie/ZEDS = new(F.loc)	//Have to give a var that's under zombie and call new.
				playsound(F.loc, 'sound/effects/phasein.ogg', vol = 80, vary = 1,extrarange = 6)

//Ripped spider_infestation code
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(temp_vent.loc.z == 1 && !temp_vent.welded && temp_vent.network)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while((spawncount >= 1) && vents.len)
		sleep(5)
		var/obj/vent = pick(vents)
		var/mob/living/simple_animal/hostile/zombie/ZEDS = new(vent.loc)
		playsound(vent.loc, 'sound/effects/phasein.ogg', vol = 80, vary = 1,extrarange = 6)
		vents -= vent
		spawncount--

/datum/event/zombie_outbreak/announce()
	var/alertshouted = pick(
	"A Boscalian ship has jumped into our sector.",
	"Unidentified vessel has passed our perimeter, detecting blue technology.",
	"Detecting Syndicate signal.",
	"Biological scans picking up level 10 biohazard. Please find the nearest BioHazard locker and prepare for sterilization procedures.")
	command_alert(alertshouted)
	world << sound('sound/AI/spanomalies.ogg')