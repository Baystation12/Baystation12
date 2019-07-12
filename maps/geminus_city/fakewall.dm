
/turf/simulated/wall/tech/fake
	var/faction_locked

/turf/simulated/wall/tech/fake/attack_hand(mob/user)
	if(isliving(user) && (faction_locked && user.faction == src.faction_locked))
		src.visible_message("<span class='info'>[src] slides back to reveal a hidden area!</span>")
		for(var/obj/machinery/light/S in get_step(src,dir))
			S.seton(1)
		var/olddir = src.dir
		var/oldfaction = faction_locked
		src.ChangeTurf(/turf/simulated/floor/plating/fakewall)
		src.dir = olddir
		src.faction_locked = oldfaction
	else
		. = ..()

/turf/simulated/floor/plating/fakewall
	var/revert_time = 0
	var/open_duration = 50
	var/faction_locked

/turf/simulated/floor/plating/fakewall/New()
	. = ..()
	revert_time = world.time + open_duration
	GLOB.processing_objects.Add(src)

/turf/simulated/floor/plating/fakewall/process()
	if(world.time >= revert_time)
		src.visible_message("<span class='info'>[src] slides forward to hide its contents.</span>")
		for(var/obj/machinery/light/S in get_step(src,dir))
			S.seton(0)
		var/oldfaction = faction_locked
		var/olddir = src.dir
		src.ChangeTurf(/turf/simulated/wall/tech/fake)
		src.dir = olddir
		src.faction_locked = oldfaction
