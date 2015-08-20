/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	opacity = 0
	time_to_live = 300
	pass_flags = PASSTABLE | PASSGRILLE | PASSGLASS //PASSGLASS is fine here, it's just so the visual effect can "flow" around glass

/obj/effect/effect/smoke/chem/New()
	..()
	create_reagents(500)
	return

/datum/effect/effect/system/smoke_spread/chem
	smoke_type = /obj/effect/effect/smoke/chem
	var/obj/chemholder
	var/range
	var/list/targetTurfs
	var/list/wallList
	var/density
	var/show_log = 1

/datum/effect/effect/system/smoke_spread/chem/spores
	show_log = 0
	var/datum/seed/seed

/datum/effect/effect/system/smoke_spread/chem/spores/New(seed_name)
	if(seed_name && plant_controller)
		seed = plant_controller.seeds[seed_name]
	if(!seed)
		qdel(src)
	..()

/datum/effect/effect/system/smoke_spread/chem/New()
	..()
	chemholder = new/obj()
	chemholder.create_reagents(500)

//Sets up the chem smoke effect
// Calculates the max range smoke can travel, then gets all turfs in that view range.
// Culls the selected turfs to a (roughly) circle shape, then calls smokeFlow() to make
// sure the smoke can actually path to the turfs. This culls any turfs it can't reach.
/datum/effect/effect/system/smoke_spread/chem/set_up(var/datum/reagents/carry = null, n = 10, c = 0, loca, direct)
	range = n * 0.3
	cardinals = c
	carry.trans_to_obj(chemholder, carry.total_volume, copy = 1)

	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(!location)
		return

	targetTurfs = new()

	//build affected area list
	for(var/turf/T in view(range, location))
		//cull turfs to circle
		if(sqrt((T.x - location.x)**2 + (T.y - location.y)**2) <= range)
			targetTurfs += T

	wallList = new()

	smokeFlow() //pathing check

	//set the density of the cloud - for diluting reagents
	density = max(1, targetTurfs.len / 4) //clamp the cloud density minimum to 1 so it cant multiply the reagents

	//Admin messaging
	var/contained = carry.get_reagents()
	var/area/A = get_area(location)

	var/where = "[A.name] | [location.x], [location.y]"
	var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

	if(show_log)
		if(carry.my_atom.fingerprintslast)
			var/mob/M = get_mob_by_key(carry.my_atom.fingerprintslast)
			var/more = ""
			if(M)
				more = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>?</a>)"
			message_admins("A chemical smoke reaction has taken place in ([whereLink])[contained]. Last associated key is [carry.my_atom.fingerprintslast][more].", 0, 1)
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. Last associated key is [carry.my_atom.fingerprintslast].")
		else
			message_admins("A chemical smoke reaction has taken place in ([whereLink]). No associated key.", 0, 1)
			log_game("A chemical smoke reaction has taken place in ([where])[contained]. No associated key.")

//Runs the chem smoke effect
// Spawns damage over time loop for each reagent held in the cloud.
// Applies reagents to walls that affect walls (only thermite and plant-b-gone at the moment).
// Also calculates target locations to spawn the visual smoke effect on, so the whole area
// is covered fairly evenly.
/datum/effect/effect/system/smoke_spread/chem/start()
	if(!location)
		return

	if(chemholder.reagents.reagent_list.len) //reagent application - only run if there are extra reagents in the smoke
		for(var/turf/T in wallList)
			chemholder.reagents.touch_turf(T)
		for(var/turf/T in targetTurfs)
			chemholder.reagents.touch_turf(T)
			for(var/atom/A in T.contents)
				if(istype(A, /obj/effect/effect/smoke/chem) || istype(A, /mob))
					continue
				else if(isobj(A) && !A.simulated)
					chemholder.reagents.touch_obj(A)

	var/color = chemholder.reagents.get_color() //build smoke icon
	var/icon/I
	if(color)
		I = icon('icons/effects/chemsmoke.dmi')
		I += color
	else
		I = icon('icons/effects/96x96.dmi', "smoke")

	var/const/arcLength = 2.3559 //distance between each smoke cloud

	for(var/i = 0, i < range, i++) //calculate positions for smoke coverage - then spawn smoke
		var/radius = i * 1.5
		if(!radius)
			spawn(0)
				spawnSmoke(location, I, 1)
			continue

		var/offset = 0
		var/points = round((radius * 2 * M_PI) / arcLength)
		var/angle = round(ToDegrees(arcLength / radius), 1)

		if(!IsInteger(radius))
			offset = 45		//degrees

		for(var/j = 0, j < points, j++)
			var/a = (angle * j) + offset
			var/x = round(radius * cos(a) + location.x, 1)
			var/y = round(radius * sin(a) + location.y, 1)
			var/turf/T = locate(x,y,location.z)
			if(!T)
				continue
			if(T in targetTurfs)
				spawn(0)
					spawnSmoke(T, I, range)

//------------------------------------------
// Randomizes and spawns the smoke effect.
// Also handles deleting the smoke once the effect is finished.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/proc/spawnSmoke(var/turf/T, var/icon/I, var/dist = 1, var/obj/effect/effect/smoke/chem/passed_smoke)

	var/obj/effect/effect/smoke/chem/smoke
	if(passed_smoke)
		smoke = passed_smoke
	else
		smoke = PoolOrNew(/obj/effect/effect/smoke/chem, location)

	if(chemholder.reagents.reagent_list.len)
		chemholder.reagents.trans_to_obj(smoke, chemholder.reagents.total_volume / dist, copy = 1) //copy reagents to the smoke so mob/breathe() can handle inhaling the reagents
	smoke.icon = I
	smoke.layer = 6
	smoke.set_dir(pick(cardinal))
	smoke.pixel_x = -32 + rand(-8, 8)
	smoke.pixel_y = -32 + rand(-8, 8)
	walk_to(smoke, T)
	smoke.opacity = 1		//switching opacity on after the smoke has spawned, and then
	sleep(150+rand(0,20))	// turning it off before it is deleted results in cleaner
	smoke.opacity = 0		// lighting and view range updates
	fadeOut(smoke)
	qdel(src)

/datum/effect/effect/system/smoke_spread/chem/spores/spawnSmoke(var/turf/T, var/icon/I, var/dist = 1)
	var/obj/effect/effect/smoke/chem/spores = PoolOrNew(/obj/effect/effect/smoke/chem, location)
	spores.name = "cloud of [seed.seed_name] [seed.seed_noun]"
	..(T, I, dist, spores)

/datum/effect/effect/system/smoke_spread/chem/proc/fadeOut(var/atom/A, var/frames = 16) // Fades out the smoke smoothly using it's alpha variable.
	if(A.alpha == 0) //Handle already transparent case
		return
	if(frames == 0)
		frames = 1 //We will just assume that by 0 frames, the coder meant "during one frame".
	var/step = A.alpha / frames
	for(var/i = 0, i < frames, i++)
		A.alpha -= step
		sleep(world.tick_lag)
	return


/datum/effect/effect/system/smoke_spread/chem/proc/smokeFlow() // Smoke pathfinder. Uses a flood fill method based on zones to quickly check what turfs the smoke (airflow) can actually reach.

	var/list/pending = new()
	var/list/complete = new()

	pending += location

	while(pending.len)
		for(var/turf/current in pending)
			for(var/D in cardinal)
				var/turf/target = get_step(current, D)
				if(wallList)
					if(istype(target, /turf/simulated/wall))
						if(!(target in wallList))
							wallList += target
						continue

				if(target in pending)
					continue
				if(target in complete)
					continue
				if(!(target in targetTurfs))
					continue
				if(current.c_airblock(target)) //this is needed to stop chemsmoke from passing through thin window walls
					continue
				if(target.c_airblock(current))
					continue
				pending += target

			pending -= current
			complete += current

	targetTurfs = complete

	return
