
/obj/structure/biomass
	name = "Flood biomass"
	desc = "A pulsating mass of flesh."
	icon = 'flood_bio.dmi'
	icon_state = "biomass1"
	density = 0
	opacity = 1
	anchored = 1
	var/datum/flood_spawner/flood_spawner
	var/max_flood = 10
	var/respawn_delay = 600

/obj/structure/biomass/New()
	..()
	flood_spawner = new(src, max_flood, respawn_delay)
	icon_state = pick(icon_states(icon))

//not necessary if they all spawn in the bottom left corner
/*/obj/structure/biomass/Bump(var/atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living/simple_animal/hostile/flood))
		AM.loc = get_step(AM, AM.dir)*/

/obj/structure/biomass/medium
	icon = 'flood_bio_med.dmi'
	max_flood = 20
	respawn_delay = 500
	bound_width = 64
	bound_height = 64

/obj/structure/biomass/large
	icon = 'flood_bio_large.dmi'
	max_flood = 30
	respawn_delay = 400
	bound_width = 128
	bound_height = 128
