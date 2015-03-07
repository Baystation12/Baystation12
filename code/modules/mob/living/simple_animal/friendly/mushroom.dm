/mob/living/simple_animal/mushroom
	name = "walking mushroom"
	desc = "It's a massive mushroom... with legs?"
	icon_state = "mushroom"
	icon_living = "mushroom"
	icon_dead = "mushroom_dead"
	small = 1
	speak_chance = 0
	turns_per_move = 1
	maxHealth = 5
	health = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	harm_intent_damage = 5
	var/datum/seed/seed

/mob/living/simple_animal/mushroom/verb/spawn_spores()

	set name = "Explode"
	set category = "Abilities"
	set desc = "Spread your spores!"
	set src = usr

	if(stat == 2)
		usr << "<span class='danger'>You are dead; it is too late for that.</span>"
		return

	if(!seed)
		usr << "<span class='danger'>You are sterile!</span>"
		return

	spore_explode()

/mob/living/simple_animal/mushroom/death()
	if(prob(30))
		spore_explode()
		return
	..()

/mob/living/simple_animal/mushroom/proc/spore_explode()

	if(!seed)
		return

	var/list/target_turfs = list()
	for(var/turf/new_turf in orange(1,src))
		if(prob(60) && !new_turf.density && src.Adjacent(new_turf)) target_turfs |= new_turf
	for(var/turf/target_turf in target_turfs)
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(target_turf,seed)
	seed.thrown_at(src,get_turf(src),1)
	if(src)
		gib()
