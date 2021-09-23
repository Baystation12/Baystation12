/mob/living/simple_animal/passive/mushroom
	name = "walking mushroom"
	desc = "It's a massive mushroom... with legs?"
	icon_state = "mushroom"
	icon_living = "mushroom"
	icon_dead = "mushroom_dead"
	mob_size = MOB_SMALL
	turns_per_move = 1
	maxHealth = 5
	health = 5
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	harm_intent_damage = 5
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/reagent_containers/food/snacks/hugemushroomslice
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   null
	density = FALSE

	var/datum/seed/seed
	var/harvest_time
	var/min_explode_time = 1200
	var/global/total_mushrooms = 0

	ai_holder_type = /datum/ai_holder/simple_animal/passive/mushroom

/mob/living/simple_animal/passive/mushroom/New()
	..()
	harvest_time = world.time
	total_mushrooms++

/mob/living/simple_animal/passive/mushroom/verb/spawn_spores()

	set name = "Explode"
	set category = "Abilities"
	set desc = "Spread your spores!"
	set src = usr

	if(stat == 2)
		to_chat(usr, "<span class='danger'>You are dead; it is too late for that.</span>")
		return

	if(!seed)
		to_chat(usr, "<span class='danger'>You are sterile!</span>")
		return

	if(world.time < harvest_time + min_explode_time)
		to_chat(usr, "<span class='danger'>You are not mature enough for that.</span>")
		return

	spore_explode()

/mob/living/simple_animal/passive/mushroom/death(gibbed, deathmessage, show_dead_message)
	. = ..(gibbed, deathmessage, show_dead_message)
	if(.)
		total_mushrooms--
		if(total_mushrooms < config.maximum_mushrooms && prob(30))
			spore_explode()

/mob/living/simple_animal/passive/mushroom/proc/spore_explode()
	if(!seed)
		return
	if(world.time < harvest_time + min_explode_time)
		return
	for(var/turf/simulated/target_turf in orange(1,src))
		if(prob(60) && !target_turf.density && src.Adjacent(target_turf))
			new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(target_turf,seed)
	death(0)
	seed.thrown_at(src,get_turf(src),1)
	if(src)
		qdel(src)

/datum/ai_holder/simple_animal/passive/mushroom
	speak_chance = 0
