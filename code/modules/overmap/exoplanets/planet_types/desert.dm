/obj/effect/overmap/visitable/sector/exoplanet/desert
	name = "desert exoplanet"
	desc = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."
	color = "#a08444"
	planetary_area = /area/exoplanet/desert
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#420d22")
	map_generators = list(/datum/random_map/noise/exoplanet/desert, /datum/random_map/noise/ore/rich)
	surface_color = "#d6cca4"
	water_color = null

/obj/effect/overmap/visitable/sector/exoplanet/desert/generate_map()
	if(prob(70))
		lightlevel = rand(5,10)/10	//deserts are usually :lit:
	..()

/obj/effect/overmap/visitable/sector/exoplanet/desert/generate_atmosphere()
	..()
	if(atmosphere)
		var/limit = 1000
		if(habitability_class <= HABITABILITY_OKAY)
			var/datum/species/human/H = /datum/species/human
			limit = initial(H.heat_level_1) - rand(1,10)
		atmosphere.temperature = min(T20C + rand(20, 100), limit)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/desert/adapt_seed(var/datum/seed/S)
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
	flora_diversity = 4
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/voxslug, /mob/living/simple_animal/hostile/antlion)
	megafauna_types = list(/mob/living/simple_animal/hostile/antlion/mega)

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(var/value, var/turf/T)
	..()
	if(is_edge_turf(T))
		return
	var/v = noise2value(value)
	if(v > 6)
		T.icon_state = "desert[v-1]"
		if(prob(10))
			new/obj/structure/quicksand(T)

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/obj/structure/quicksand
	name = "sand"
	icon = 'icons/obj/quicksand.dmi'
	icon_state = "intact0"
	density = 0
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	var/exposed = 0
	var/busy

/obj/structure/quicksand/New()
	icon_state = "intact[rand(0,2)]"
	..()

/obj/structure/quicksand/user_unbuckle_mob(mob/user)
	if(buckled_mob && !user.stat && !user.restrained())
		if(busy)
			to_chat(user, "<span class='wanoticerning'>[buckled_mob] is already getting out, be patient.</span>")
			return
		var/delay = 60
		if(user == buckled_mob)
			delay *=2
			user.visible_message(
				"<span class='notice'>\The [user] tries to climb out of \the [src].</span>",
				"<span class='notice'>You begin to pull yourself out of \the [src].</span>",
				"<span class='notice'>You hear water sloushing.</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>\The [user] begins pulling \the [buckled_mob] out of \the [src].</span>",
				"<span class='notice'>You begin to pull \the [buckled_mob] out of \the [src].</span>",
				"<span class='notice'>You hear water sloushing.</span>"
				)
		busy = 1
		if(do_after(user, delay, src))
			busy = 0
			if(user == buckled_mob)
				if(prob(80))
					to_chat(user, "<span class='warning'>You slip and fail to get out!</span>")
					return
				user.visible_message("<span class='notice'>\The [buckled_mob] pulls himself out of \the [src].</span>")
			else
				user.visible_message("<span class='notice'>\The [buckled_mob] has been freed from \the [src] by \the [user].</span>")
			unbuckle_mob()
		else
			busy = 0
			to_chat(user, "<span class='warning'>You slip and fail to get out!</span>")
			return

/obj/structure/quicksand/unbuckle_mob()
	..()
	update_icon()

/obj/structure/quicksand/buckle_mob(var/mob/L)
	..()
	update_icon()

/obj/structure/quicksand/on_update_icon()
	if(!exposed)
		return
	icon_state = "open"
	overlays.Cut()
	if(buckled_mob)
		overlays += buckled_mob
		var/image/I = image(icon,icon_state="overlay")
		I.layer = ABOVE_HUMAN_LAYER
		overlays += I

/obj/structure/quicksand/proc/expose()
	if(exposed)
		return
	visible_message("<span class='warning'>The upper crust breaks, exposing treacherous quicksands underneath!</span>")
	name = "quicksand"
	desc = "There is no candy at the bottom."
	exposed = 1
	update_icon()

/obj/structure/quicksand/attackby(obj/item/weapon/W, mob/user)
	if(!exposed && W.force)
		expose()
	else
		..()

/obj/structure/quicksand/Crossed(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.throwing || L.can_overcome_gravity())
			return
		buckle_mob(L)
		if(!exposed)
			expose()
		to_chat(L, SPAN_DANGER("You fall into \the [src]!"))
