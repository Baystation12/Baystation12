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
			if(amount < 0.1) return
			var/turf/simulated/S = loc
			if(!istype(S)) return

			for(var/d in list(turn(dir,90),turn(dir,-90), dir))
				var/turf/simulated/O = get_step(S,d)
				if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in O)
					continue
				if(O.CanPass(null, S, 0, 0) && S.CanPass(null, O, 0, 0))
					new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(O,amount*0.25,d)
					O.hotspot_expose((T20C*2) + 380,500) //Light flamethrower fuel on fire immediately.

			amount *= 0.25


/obj/effect/decal/cleanable/liquid_fuel/Initialize()
	var/has_spread = 0
	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in loc)
		if(other != src)
			other.amount += src.amount
			other.Spread()
			has_spread = 1
			break

	. = ..()
	if(!has_spread)
		Spread()
	else
		return INITIALIZE_HINT_QDEL
