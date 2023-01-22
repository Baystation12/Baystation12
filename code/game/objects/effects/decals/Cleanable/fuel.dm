/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = BLOOD_LAYER
	var/amount = 1
	cleanable_scent = "fuel"

/obj/effect/decal/cleanable/liquid_fuel/proc/Spread(exclude=list())
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

/obj/effect/decal/cleanable/liquid_fuel/Initialize(mapload, amt=1, nologs=FALSE)
	if(!nologs && !mapload)
		log_and_message_admins(" - Liquid fuel has been spilled in [get_area(loc)]", location = loc)
	src.amount = amt
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
