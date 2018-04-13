
/datum/ghost_role/flood_combat_form

	mob_to_spawn = /mob/living/simple_animal/hostile/flood/combat_form/human
	objects_spawn_on = list(/obj/effect/landmark/flood_spawn,/obj/structure/biomass)

/datum/ghost_role/flood_combat_form/post_spawn(var/mob/observer/ghost/ghost,var/obj/chosen_spawn,var/mob/living/simple_animal/created_mob)
	created_mob.name = ghost.name
	created_mob.maxHealth = 100
	created_mob.health = 100
