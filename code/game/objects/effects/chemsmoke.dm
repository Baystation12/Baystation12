/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'
	opacity = 0
	time_to_live = 300
	pass_flags = PASSTABLE | PASSGRILLE | PASSGLASS		//PASSGLASS is fine here, it's just so the visual effect can "flow" around glass

/obj/effect/effect/smoke/chem/New()
	..()
	var/datum/reagents/R = new/datum/reagents(500)
	reagents = R
	R.my_atom = src
	return

/datum/effect/effect/system/smoke_spread/chem
	smoke_type = /obj/effect/effect/smoke/chem
	var/obj/chemholder
	var/range
	var/list/targetTurfs
	var/list/wallList
	var/density


/datum/effect/effect/system/smoke_spread/chem/New()
	..()
	chemholder = new/obj()
	var/datum/reagents/R = new/datum/reagents(500)
	chemholder.reagents = R
	R.my_atom = chemholder

//------------------------------------------
//Sets up the chem smoke effect
//
// Calculates the max range smoke can travel, then gets all turfs in that view range.
// Culls the selected turfs to a (roughly) circle shape, then calls smokeFlow() to make
// sure the smoke can actually path to the turfs. This culls any turfs it can't reach.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/set_up(var/datum/reagents/carry = null, n = 10, c = 0, loca, direct)
	range = n * 0.3
	cardinals = c
	carry.copy_to(chemholder, carry.total_volume)

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
		if(cheap_pythag(T.x - location.x, T.y - location.y) <= range)
			targetTurfs += T

	//make secondary list for reagents that affect walls
	if(chemholder.reagents.has_reagent("thermite") || chemholder.reagents.has_reagent("plantbgone"))
		wallList = new()

	//pathing check
	smokeFlow(location, targetTurfs, wallList)

	//set the density of the cloud - for diluting reagents
	density = max(1, targetTurfs.len / 4)	//clamp the cloud density minimum to 1 so it cant multiply the reagents

	//Admin messaging
	var/contained = ""
	for(var/reagent in carry.reagent_list)
		contained += " [reagent] "
	if(contained)
		contained = "\[[contained]\]"
	var/area/A = get_area(location)

	var/where = "[A.name] | [location.x], [location.y]"
	var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>[where]</a>"

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


//------------------------------------------
//Runs the chem smoke effect
//
// Spawns damage over time loop for each reagent held in the cloud.
// Applies reagents to walls that affect walls (only thermite and plant-b-gone at the moment).
// Also calculates target locations to spawn the visual smoke effect on, so the whole area
// is covered fairly evenly.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/start()

	if(!location)	//kill grenade if it somehow ends up in nullspace
		return

	//reagent application - only run if there are extra reagents in the smoke
	if(chemholder.reagents.reagent_list.len)
		for(var/datum/reagent/R in chemholder.reagents.reagent_list)
			var/proba = 100
			var/runs = 5

			//dilute the reagents according to cloud density
			R.volume /= density
			chemholder.reagents.update_total()

			//apply wall affecting reagents to walls
			if(R.id in list("thermite", "plantbgone"))
				for(var/turf/T in wallList)
					R.reaction_turf(T, R.volume)

			//reagents that should be applied to turfs in a random pattern
			if(R.id == "carbon")
				proba = 75
			else if(R.id in list("blood", "radium", "uranium"))
				proba = 25

			spawn(0)
				for(var/i = 0, i < runs, i++)
					for(var/turf/T in targetTurfs)
						if(prob(proba))
							R.reaction_turf(T, R.volume)
						for(var/atom/A in T.contents)
							if(istype(A, /obj/effect/effect/smoke/chem))	//skip the item if it is chem smoke
								continue
							else if(istype(A, /mob))
								var/dist = cheap_pythag(T.x - location.x, T.y - location.y)
								if(!dist)
									dist = 1
								R.reaction_mob(A, volume = R.volume / dist)
							else if(istype(A, /obj))
								R.reaction_obj(A, R.volume)
					sleep(30)


	//build smoke icon
	var/color = mix_color_from_reagents(chemholder.reagents.reagent_list)
	var/icon/I
	if(color)
		I = icon('icons/effects/chemsmoke.dmi')
		I += color
	else
		I = icon('icons/effects/96x96.dmi', "smoke")


	//distance between each smoke cloud
	var/const/arcLength = 2.3559


	//calculate positions for smoke coverage - then spawn smoke
	for(var/i = 0, i < range, i++)
		var/radius = i * 1.5
		if(!radius)
			spawn(0)
				spawnSmoke(location, I, 1)
			continue

		var/offset = 0
		var/points = round((radius * 2 * PI) / arcLength)
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
/datum/effect/effect/system/smoke_spread/chem/proc/spawnSmoke(var/turf/T, var/icon/I, var/dist = 1)
	var/obj/effect/effect/smoke/chem/smoke = new(location)
	if(chemholder.reagents.reagent_list.len)
		chemholder.reagents.copy_to(smoke, chemholder.reagents.total_volume / dist, safety = 1)	//copy reagents to the smoke so mob/breathe() can handle inhaling the reagents
	smoke.icon = I
	smoke.layer = 6
	smoke.dir = pick(cardinal)
	smoke.pixel_x = -32 + rand(-8,8)
	smoke.pixel_y = -32 + rand(-8,8)
	walk_to(smoke, T)
	smoke.opacity = 1		//switching opacity on after the smoke has spawned, and then
	sleep(150+rand(0,20))	// turning it off before it is deleted results in cleaner
	smoke.opacity = 0		// lighting and view range updates
	fadeOut(smoke)
	smoke.delete()

//------------------------------------------
// Fades out the smoke smoothly using it's alpha variable.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/proc/fadeOut(var/atom/A, var/frames = 16)
	var/step = A.alpha / frames
	for(var/i = 0, i < frames, i++)
		A.alpha -= step
		sleep(world.tick_lag)
	return

//------------------------------------------
// Smoke pathfinder. Uses a flood fill method based on zones to
// quickly check what turfs the smoke (airflow) can actually reach.
//------------------------------------------
/datum/effect/effect/system/smoke_spread/chem/proc/smokeFlow()

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
