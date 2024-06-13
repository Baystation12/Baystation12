/// Handy-dandy single-turf escape pods.
/obj/structure/closet/coffin/lifepod
	name = "life pod"
	desc = "It's a survival receptacle for the nearly departed."
	icon_state = "closed_unlocked"
	icon = 'icons/obj/closets/lifepod.dmi'
	/// If it has already launched once, it won't do it again.
	var/launched = FALSE
	/// The desired location of a bad guy if they emag this thing.
	var/obj/overmap/visitable/emag
	/// A limited amount of air used for return_air() when closed.
	var/datum/gas_mixture/airtank
	/// Starting gas mixture of airtank.
	var/list/init_airtank = list(
		GAS_OXYGEN = MOLES_O2STANDARD,
		GAS_NITROGEN = MOLES_N2STANDARD
	)
	/// Starting temperature of airtank.
	var/init_temp = T0C

/obj/structure/closet/coffin/lifepod/Initialize()
	. = ..()

	airtank = new()
	airtank.temperature = init_temp
	for(var/gas in init_airtank)
		airtank.adjust_gas(gas, init_airtank[gas])

/obj/structure/closet/coffin/lifepod/WillContain()
	return list(
		/obj/item/storage/toolbox/emergency,
		/obj/random/firstaid,
		/obj/item/pickaxe,
		/obj/item/shuttle_beacon
	)

/obj/structure/closet/coffin/lifepod/return_air()
	return airtank

/obj/structure/closet/coffin/lifepod/make_broken()
	. = ..()

	if(GLOB.using_map.use_overmap)
		var/list/visitables = list()
		for(var/string in map_sectors)
			var/obj/overmap/visitable/site = map_sectors[string]

			if(istype(site, /obj/overmap/visitable/ship/landable))
				var/obj/overmap/visitable/ship/landable/shuttle = site

				if(shuttle.status == SHIP_STATUS_OVERMAP)
					visitables += site
			else
				visitables += site

		if(!emag)
			emag = input(usr, "Where do you want to go?", "Hijacking \the [src]", null) in visitables

/obj/structure/closet/coffin/lifepod/touch_map_edge()
	if(launched)
		..()
	else
		var/turf/landing
		var/cache_z = z
		var/landing_z = GLOB.using_map.get_empty_zlevel()

		launched = TRUE
		playsound(loc,'sound/effects/rocket.ogg',100)
		forceMove(locate(rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE), landing_z))

		if(GLOB.using_map.use_overmap)
			var/obj/overmap/visitable/source = map_sectors["[cache_z]"]
			var/obj/overmap/visitable/closest
			var/dist = GLOB.using_map.overmap_size

			if(emag)
				closest = emag
			else
				for(var/obj/overmap/visitable/other in get_area(source)) // This is every visitable overmap object
					if(get_dist(source, other) < dist && other != source)
						closest = other
						dist = get_dist(source, other)

			landing_z = pick(closest.map_z)

			sleep(dist SECONDS / 2)

			for(var/mob/content in contents)
				to_chat(content, SPAN_WARNING("The pod doesn't feel like it's going to slow down..."))

			sleep(dist SECONDS / 2)

		if(!(landing_z in GLOB.using_map.empty_levels))
			while(!landing || landing.density || isspaceturf(landing) || isopenspace(landing))
				landing = locate(rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE), landing_z)

			visible_message(SPAN_DANGER("\The [src] crashes into \the [landing]!"))
			explosion(landing, rand(5, 10))

			forceMove(landing)
