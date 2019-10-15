/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	plane = ABOVE_TURF_PLANE
	layer = BLOOD_LAYER
	anchored = 1
	var/amount = 1

	New(turf/newLoc,amt=1,nologs=0)
		..()
		if(!nologs)
			log_and_message_admins(" - Liquid fuel has been spilled")
		src.amount = amt

	proc/Spread(exclude=list())
		//Allows liquid fuels to sometimes flow into other tiles.
		if(amount < 15) return //lets suppose welder fuel is fairly thick and sticky. For something like water, 5 or less would be more appropriate.
		var/turf/simulated/S = loc
		if(!istype(S)) return
		for(var/d in GLOB.cardinal)
			var/turf/simulated/target = get_step(src,d)
			var/turf/simulated/origin = get_turf(src)
			if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
				var/obj/effect/decal/cleanable/liquid_fuel/other_fuel = locate() in target
				if(other_fuel)
					other_fuel.amount += amount*0.25
					if(!(other_fuel in exclude))
						exclude += src
						other_fuel.Spread(exclude)
				else
					new/obj/effect/decal/cleanable/liquid_fuel(target, amount*0.25,1)
				amount *= 0.75


	flamethrower_fuel
		icon_state = "mustard"
		anchored = 0
		New(newLoc, amt = 1, d = 0)
			set_dir(d) //Setting this direction means you won't get torched by your own flamethrower.
			..()

		Spread()
			//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
			//if(amount < 0.1) return
			var/turf/simulated/start_turf = loc
			if(!istype(start_turf)) return

			//we want a minimum of 1.5 fuel per turf, as under optimum burn conditions 0.25 will be consumed per tick (therefore 6 tick duration)
			var/max_turfs = amount / 1.5
			var/max_dist = sqrt(max_turfs)		//take the square root to give us the radius

			var/list/unspread_turfs = list(start_turf)
			var/list/new_fuel = list(src)
			while(unspread_turfs.len)
				var/turf/simulated/check_turf = unspread_turfs[1]

				for(var/turf/simulated/adjacent in orange(1, check_turf))
					if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in adjacent)
						continue

					if(get_dist(start_turf, adjacent) > max_dist)
						continue

					if(adjacent.Enter(src, start_turf))
						unspread_turfs |= adjacent

				var/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/F = new(check_turf, 1.5, src.dir)
				new_fuel.Add(F)
				new /obj/effect/fire(check_turf)

				unspread_turfs.Remove(check_turf)

			var/spread_amount = amount / new_fuel.len
			for(var/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/F in new_fuel)
				F.amount = spread_amount


/obj/effect/decal/cleanable/liquid_fuel/Initialize()
	. = ..()

	if(amount < 0.05)
		return INITIALIZE_HINT_QDEL

	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in loc)
		if(other != src)
			other.amount += src.amount
			return INITIALIZE_HINT_QDEL
