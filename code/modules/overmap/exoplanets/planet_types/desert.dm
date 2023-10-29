/obj/overmap/visitable/sector/exoplanet/desert
	name = "desert exoplanet"
	desc = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."
	color = "#a08444"
	planetary_area = /area/exoplanet/desert
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#420d22")
	map_generators = list(/datum/random_map/noise/exoplanet/desert, /datum/random_map/noise/ore/rich)
	surface_color = "#d6cca4"
	water_color = null
	has_trees = FALSE
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/voxslug, /mob/living/simple_animal/hostile/retaliate/beast/antlion)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/beast/antlion/mega)

/obj/overmap/visitable/sector/exoplanet/desert/generate_map()
	if(prob(70))
		sun_brightness_modifier = rand(4,8)/10	//deserts are usually :lit:
	..()

/obj/overmap/visitable/sector/exoplanet/desert/generate_atmosphere()
	..()
	var/datum/species/H = all_species[SPECIES_HUMAN]
	var/generator/new_temp = generator("num", H.heat_level_1, 2 * H.heat_level_1, NORMAL_RAND)
	atmosphere.temperature = new_temp.Rand()
	atmosphere.update_values()

/obj/overmap/visitable/sector/exoplanet/desert/adapt_seed(datum/seed/S)
	..()
	if(prob(90))
		S.set_trait(TRAIT_REQUIRES_WATER,0)
	else
		S.set_trait(TRAIT_REQUIRES_WATER,1)
		S.set_trait(TRAIT_WATER_CONSUMPTION,1)
	if(prob(75))
		S.set_trait(TRAIT_STINGS,1)
	if(prob(75))
		S.set_trait(TRAIT_CARNIVOROUS,2)
	S.set_trait(TRAIT_SPREAD,0)

/datum/random_map/noise/exoplanet/desert
	descriptor = "desert exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/desert

	flora_prob = 5
	large_flora_prob = 0

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(value, turf/T)
	..()
	var/v = noise2value(value)
	if(v > 6 && prob(2))
		new/obj/quicksand(T)

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/obj/quicksand
	name = "quicksand"
	desc = "There is no candy at the bottom."
	icon = 'icons/obj/structures/quicksand.dmi'
	icon_state = "intact0"
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	var/exposed = FALSE
	var/busy

/obj/quicksand/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	appearance = T.appearance

/obj/quicksand/user_unbuckle_mob(mob/user)
	if (!can_unbuckle(user))
		return
	if (!user.stat && !user.restrained())
		if(busy)
			to_chat(user, SPAN_NOTICE("\The [buckled_mob] is already getting out, be patient."))
			return
		var/delay = 6 SECONDS
		if(user == buckled_mob)
			delay *=2
			user.visible_message(
				SPAN_NOTICE("\The [user] tries to climb out of \the [src]."),
				SPAN_NOTICE("You begin to pull yourself out of \the [src]."),
				SPAN_NOTICE("You hear water sloshing.")
				)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] begins pulling \the [buckled_mob] out of \the [src]."),
				SPAN_NOTICE("You begin to pull \the [buckled_mob] out of \the [src]."),
				SPAN_NOTICE("You hear water sloshing.")
				)
		busy = TRUE
		if(do_after(user, delay, src, DO_PUBLIC_UNIQUE) && can_unbuckle(user))
			busy = FALSE
			if(user == buckled_mob)
				if(prob(80))
					to_chat(user, SPAN_WARNING("You slip and fail to get out!"))
					return
				user.visible_message(SPAN_NOTICE("\The [buckled_mob] pulls himself out of \the [src]."))
			else
				user.visible_message(SPAN_NOTICE("\The [buckled_mob] has been freed from \the [src] by \the [user]."))
			unbuckle_mob()
		else
			busy = FALSE
			to_chat(user, SPAN_WARNING("You slip and fail to get out!"))
			return

/obj/quicksand/unbuckle_mob()
	..()
	update_icon()

/obj/quicksand/buckle_mob(mob/L)
	..()
	update_icon()

/obj/quicksand/on_update_icon()
	if(!exposed)
		return
	icon_state = "open"
	ClearOverlays()
	if(buckled_mob)
		AddOverlays(image(icon,icon_state="overlay",layer=ABOVE_HUMAN_LAYER))

/obj/quicksand/proc/expose()
	if(exposed)
		return
	visible_message(SPAN_WARNING("The upper crust breaks, exposing the treacherous quicksand underneath!"))
	SetName(initial(name))
	desc = initial(desc)
	icon = initial(icon)
	exposed = 1
	update_icon()


/obj/quicksand/use_tool(obj/item/tool, mob/user, list/click_params)
	// Any object - Expose the quicksand
	if (!exposed && tool.force)
		expose()
		return TRUE

	return ..()


/obj/quicksand/Crossed(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.throwing || L.can_overcome_gravity() || !can_buckle(L))
			return
		buckle_mob(L)
		if(!exposed)
			expose()
		to_chat(L, SPAN_DANGER("You fall into \the [src]!"))
