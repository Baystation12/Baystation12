
/obj/structure/biomass
	name = "Flood biomass"
	desc = "A pulsating mass of flesh."
	icon = 'flood_bio.dmi'
	icon_state = "biomass1"
	density = 1
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

/obj/item/flood_spore
	icon = 'flood_bio.dmi'
	icon_state = "spore1"
	mouse_opacity = 0
	randpixel = 4

/obj/item/flood_spore/New()
	..()
	icon_state = "spore[rand(1,8)]"

/obj/item/flood_spore_growing
	icon = 'flood_bio.dmi'
	icon_state = "animated"
	mouse_opacity = 0
	randpixel = 4

/obj/item/flood_spore_growing/New()
	..()
	icon_state = "animated[rand(1,6)]"

/obj/structure/biomass/tiny
	icon = 'flood_bio.dmi'
	icon_state = "pulsating"
	max_flood = 3
	respawn_delay = 300
