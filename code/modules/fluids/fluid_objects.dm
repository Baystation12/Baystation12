// Object for removing water.
/obj/structure/drain
	name = "drain"
	desc = "You probably can't get sucked into it, hopefully."
	icon_state = "drain"
	anchored = 1
	density = 0
	opacity = 0
	layer = 2.1

/obj/structure/drain/water_act()
	var/obj/effect/fluid/F = locate() in loc
	if(istype(F) && F.depth > FLUID_EVAPORATION_POINT)
		if(prob(25)) visible_message("<span class='notice'>\The [src] gurgles.</span>")
		F.lose_fluid(round(F.depth/2)+5)

// Object for spawning water at roundstart via the map.
/obj/item/fluid_spawn
	name = "water placeholder"
	desc = "If this exists post-roundstart please contact a developer."
	icon = 'icons/effects/liquid.dmi'
	icon_state = "water"
	invisibility = INVISIBILITY_MAXIMUM
	var/fluid_spawn_amt = 100

/obj/item/fluid_spawn/New()
	..()
	if(fluid_controller_exists)
		spawn_fluid()

// Called by the fluid controller on creation.
/obj/item/fluid_spawn/proc/spawn_fluid()
	var/obj/effect/fluid/F = locate() in loc
	if(!F) F = PoolOrNew(/obj/effect/fluid, loc)
	F.recieve_fluid(fluid_spawn_amt)
	qdel(src)

/obj/item/fluid_spawn/pool
	name = "pool water placeholder"
	fluid_spawn_amt = 65 // Let's not instantly drown anyone who uses the pool.

/turf/simulated/floor/pool
	name = "pool floor"
	desc = "Watch your step."
	icon_state = "poolfloor"
