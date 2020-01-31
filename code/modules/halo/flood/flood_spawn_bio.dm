
/obj/structure/biomass
	name = "Flood biomass"
	desc = "A pulsating mass of flesh."
	icon = 'flood_bio.dmi'
	icon_state = "spore1"
	density = 0
	opacity = 1
	anchored = 1
	var/health = 500
	var/datum/flood_spawner/flood_spawner
	var/list/spawn_pool = list()
	var/max_flood = 10
	var/respawn_delay = 600

/obj/structure/biomass/New()
	. = ..()
	flood_spawner = new(src, max_flood, respawn_delay,spawn_pool)
	//icon_state = pick(icon_states(icon)) //Let's not randomise this unless our biomass-subtype wants us to.

//not necessary if they all spawn in the bottom left corner
/*/obj/structure/biomass/Bump(var/atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living/simple_animal/hostile/flood))
		AM.loc = get_step(AM, AM.dir)*/

/obj/structure/biomass/examine(var/examiner)
	. = ..()
	var/status = health / initial(health)
	if(status > 0.66)
		to_chat(examiner,"<span class = 'info'>[src] looks very healthy.</span>")
	else if(status > 0.33)
		to_chat(examiner,"<span class = 'notice'>[src] looks damaged.</span>")
	else
		to_chat(examiner,"<span class = 'warning'>[src] is heavily damaged!</span>")

/obj/structure/biomass/proc/take_damage(var/amount, var/damage_type)
	health -= amount

	//double damage from fire
	if(damage_type == BURN)
		health -= amount

	if(health <= 0)
		if(damage_type == BURN)
			src.visible_message("<span class='danger'>[src] is roasted to cinders and disintegrates into ash!</span>")
		else
			src.visible_message("<span class='danger'>[src] is torn apart and disintegrates into shreds!</span>")
		qdel(flood_spawner)
		qdel(src)

/obj/structure/biomass/attackby(var/obj/item/I, var/mob/living/user)
	. = ..()
	take_damage(I.force, damtype)

/obj/structure/biomass/bullet_act(var/obj/item/projectile/Proj)
	. = ..()
	take_damage(Proj.damage, Proj.damage_type)

/obj/structure/biomass/ex_act(var/severity)

	if(severity == 1)
		take_damage(250, BURN)
	else if(severity == 2)
		take_damage(100, BURN)
	else
		take_damage(50, BURN)

/obj/structure/biomass/medium
	icon = 'flood_bio_med.dmi'
	health = 1000
	max_flood = 20
	respawn_delay = 500
	bound_width = 64
	bound_height = 64

/obj/structure/biomass/medium/New()
	. = ..()
	icon_state = pick(icon_states(icon))

/obj/structure/biomass/large
	icon = 'flood_bio_large.dmi'
	health = 2000
	max_flood = 30
	respawn_delay = 400
	bound_width = 128
	bound_height = 128
/obj/structure/biomass/large/New()
	. = ..()
	icon_state = pick(icon_states(icon))

/obj/item/flood_spore
	icon = 'flood_bio.dmi'
	icon_state = "spore1"
	mouse_opacity = 0
	randpixel = 4

/obj/item/flood_spore/New()
	. = ..()
	icon_state = "spore[rand(1,8)]"

/obj/item/flood_spore_growing
	icon = 'flood_bio.dmi'
	icon_state = "animated"
	mouse_opacity = 0
	randpixel = 4

/obj/item/flood_spore_growing/New()
	. = ..()
	icon_state = "animated[rand(1,6)]"

/obj/structure/biomass/tiny
	icon = 'flood_bio.dmi'
	icon_state = "pulsating"
	max_flood = 3
	/datum/flood_spawner/flood_spawner/achlys
	spawn_pool = list(\
	/mob/living/simple_animal/hostile/flood/combat_form/prisoner, \
	/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard, \
	/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew \
	)
	respawn_delay = 300
