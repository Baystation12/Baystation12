/obj/effect/overmap/sector/exoplanet/desert
	name = "desert exoplanet"
	desc = "An arid exoplanet with sparse biological resources but rich mineral deposits underground."
	color = "#D6CCA4"

/obj/effect/overmap/sector/exoplanet/desert/generate_map()
	if(prob(70))
		lightlevel = rand(5,10)/10	//deserts are usually :lit:
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/desert(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/rich(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/desert/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(20, 100)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/desert/adapt_seed(var/datum/seed/S)
	..()
	if(prob(90))
		S.set_trait(TRAIT_REQUIRES_WATER,0)
	else
		S.set_trait(TRAIT_REQUIRES_WATER,1)
		S.set_trait(TRAIT_WATER_CONSUMPTION,1)
	if(prob(15))
		S.set_trait(TRAIT_STINGS,1)

/datum/random_map/noise/exoplanet/desert
	descriptor = "desert exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/desert
	planetary_area = /area/exoplanet/desert
	plantcolors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#120309")

	flora_prob = 10
	large_flora_prob = 0
	flora_diversity = 4
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/tindalos)

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(var/value, var/turf/T)
	..()
	var/v = noise2value(value)
	if(v > 6)
		T.icon_state = "desert[v-1]"
		if(prob(10))
			new/obj/structure/quicksand(T)

/datum/random_map/noise/ore/rich
	deep_val = 0.7
	rare_val = 0.5

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/turf/simulated/floor/exoplanet/desert
	name = "sand"

/turf/simulated/floor/exoplanet/desert/New()
	icon_state = "desert[rand(0,5)]"
	..()

/turf/simulated/floor/exoplanet/desert/fire_act(datum/gas_mixture/air, temperature, volume)
	if((temperature > T0C + 1700 && prob(5)) || temperature > T0C + 3000)
		name = "molten silica"
		icon_state = "sandglass"
		diggable = 0

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

/obj/structure/quicksand/unbuckle_mob()
	..()
	update_icon()

/obj/structure/quicksand/buckle_mob(var/mob/L)
	..()
	update_icon()

/obj/structure/quicksand/update_icon()
	if(!exposed)
		return
	icon_state = "open"
	overlays.Cut()
	if(buckled_mob)
		overlays += buckled_mob
		var/image/I = image(icon,icon_state="overlay")
		I.plane = ABOVE_HUMAN_PLANE
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

/obj/structure/quicksand/Crossed(AM)
	if(isliving(AM))
		var/mob/living/L = AM
		buckle_mob(L)
		if(!exposed)
			expose()
		to_chat(L, "<span class='danger'>You fall into \the [src]!</span>")