/datum/species/zombie
	name = "Zombie"
	name_plural = "Zombies"
	slowdown = 15
	blood_color = "#700f0f"
	death_message = "writhes and twitches before falling motionless."
	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN
	brute_mod = 1
	burn_mod = 2.5 //Vulnerable to fire
	oxy_mod = 0
	stun_mod = 0.05
	weaken_mod = 0.05
	paralysis_mod = 0.2
	show_ssd = null //No SSD message so NPC logic can take over
	warning_low_pressure = 0
	hazard_low_pressure = 0
	body_temperature = null
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
	hidden_from_codex = TRUE

	has_fine_manipulation = FALSE
	unarmed_types = list(/datum/unarmed_attack/bite/sharp/zombie)
	move_intents = list(/decl/move_intent/creep)

	var/heal_rate = 1 // Regen.
	var/mob/living/carbon/human/target = null

	var/list/obstacles = list(/obj/structure/window,
						/obj/structure/closet,
						/obj/machinery/door/airlock,
						/obj/structure/table,
						/obj/structure/grille,
						/obj/structure/barricade,
						/obj/structure/wall_frame,
						/obj/structure/railing,
						/obj/structure/girder,
						/turf/simulated/wall/,
						/obj/machinery/door/blast/shutters,
						/obj/machinery/door/)

/datum/species/zombie/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations |= MUTATION_CLUMSY
	H.mutations |= MUTATION_FERAL
	H.mutations |= MUTATION_XRAY
	H.mutations |= mNobreath //Byond doesn't like adding them all in one OR statement :(
	H.verbs += /mob/living/carbon/proc/consume
	H.move_intents = list(/decl/move_intent/creep) //Zooming days are over
	H.a_intent = "harm"
	H.move_intent = new /decl/move_intent/creep
	H.default_run_intent = H.move_intent
	H.default_walk_intent = H.move_intent

	H.set_sight(H.sight|SEE_MOBS|SEE_OBJS|SEE_TURFS) //X-Ray vis
	H.set_see_in_dark(8)
	H.set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	H.languages = list()
	H.add_language(LANGUAGE_ZOMBIE)

	H.sleeping = 0
	H.resting = 0
	H.weakened = 0

	H.move_intent.move_delay = 6
	H.stat = CONSCIOUS

	if(H.wear_id) qdel(H.wear_id)
	if(H.gloves) qdel(H.gloves)
	if(H.head) qdel(H.head) //Remove helmet so headshots aren't impossible
	if(H.glasses) qdel(H.glasses)
	if(H.wear_mask) qdel(H.wear_mask)
	..()

/datum/species/zombie/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS)
		if(prob(5))
			playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 15, 1)
		else if(prob(5))
			playsound(H.loc, 'sound/hallucinations/veryfar_noise.ogg', 15, 1)
		else if(prob(5))
			playsound(H.loc, 'sound/hallucinations/wail.ogg', 15, 1)

	for(var/obj/item/organ/I in H.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)

	H.vessel.add_reagent(/datum/reagent/blood, min(heal_rate*10, blood_volume - H.vessel.total_volume))

	if(H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
		H.adjustBruteLoss(-heal_rate)
		H.adjustFireLoss(-heal_rate)
		H.adjustOxyLoss(-heal_rate)
		H.adjustToxLoss(-heal_rate)
		return TRUE

/datum/species/zombie/handle_death(var/mob/living/carbon/human/H)
	H.stat = DEAD //Gotta confirm death for some odd reason
	playsound(H, 'sound/hallucinations/wail.ogg', 30, 1)
	handle_death_infection(H)
	return TRUE

/datum/species/zombie/proc/handle_death_infection(var/mob/living/carbon/human/H)
	var/list/victims = hearers(H, rand(1,2))
	for(var/mob/living/carbon/human/M in victims)
		if(H == M || isspecies(M, SPECIES_ZOMBIE))
			continue
		if(!(M.species.name in ORGANIC_SPECIES) || isspecies(M,SPECIES_DIONA) || M.isFBP())
			continue
		if(M.wear_mask && (M.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT)) // If they're protected by a mask
			continue
		else if(M.head && (M.head.item_flags & ITEM_FLAG_AIRTIGHT)) // If they're protected by a helmet
			continue

		var/vuln = 1 - M.get_blocked_ratio(null, TOX, damage_flags = DAM_BIO) //Are they protected by hazmat clothing?
		if(vuln > 0.10 && prob(10))
			M.reagents.add_reagent(/datum/reagent/zombie, 0.5) //Infect 'em

	if(H && H.stat != CONSCIOUS)
		addtimer(CALLBACK(src, .proc/handle_death_infection, H), 1 SECOND)

/datum/species/zombie/handle_npc(var/mob/living/carbon/human/H)
	H.resting = FALSE
	if(H.client || H.stat != CONSCIOUS)
		walk(H, 0) //Stop dead-walking
		return

	if(prob(5))
		H.custom_emote("wails!")
	else if(prob(5))
		H.custom_emote("groans!")
	if(H.restrained() && prob(8))
		H.custom_emote("thrashes and writhes!")

	if(H.lying)
		walk(H, 0)
		return

	if(H.restrained() || H.buckled())
		H.resist()
		return

	addtimer(CALLBACK(src, .proc/handle_action, H), rand(10,20))

/datum/species/zombie/proc/handle_action(var/mob/living/carbon/human/H)
	var/dist = 128
	for(var/mob/living/M in hearers(H, 15))
		if((ishuman(M) || istype(M, /mob/living/exosuit)) && !isspecies(M, SPECIES_ZOMBIE) && !isspecies(M, SPECIES_DIONA)) //Don't attack fellow zombies, or diona
			if(istype(M, /mob/living/exosuit))
				var/mob/living/exosuit/MC = M
				if(!LAZYLEN(MC.pilots))
					continue //Don't attack empty mechs
			if(M.stat == DEAD && target)
				continue //Only eat corpses when no living (and able) targets are around
			var/D = get_dist(M, H)
			if(D <= dist*0.5) //Must be significantly closer to change targets
				target = M //For closest target
				dist = D

	H.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*2)
	if(target)
		if(isspecies(target, SPECIES_ZOMBIE))
			target = null
			return

		if(!H.Adjacent(target))
			var/turf/dir = get_step_towards(H, target)
			for(var/type in obstacles) //Break obstacles
				var/obj/obstacle = locate(type) in dir
				if(obstacle)
					H.face_atom(obstacle)
					obstacle.attack_generic(H, 10, "smashes")
					break

			walk_to(H, target.loc, 1, H.move_intent.move_delay*1.25)

		else
			if(!target.lying) //Subdue meals
				H.face_atom(target)

				if(!H.zone_sel)
					H.zone_sel = new /obj/screen/zone_sel(null)
				H.zone_sel.selecting = BP_CHEST
				target.attack_hand(H)

			else //Eat said meals
				walk_to(H, target.loc, 0, H.move_intent.move_delay*2.5) //Move over them
				if(H.Adjacent(target)) //Check we're still next to them
					H.consume()

		for(var/mob/living/M in hearers(H, 15))
			if(target == M) //If our target is still nearby
				return
		target = null //Target lost

	else
		if(!H.lying)
			walk(H, 0) //Clear walking
			if(prob(33) && isturf(H.loc) && !H.pulledby)
				H.SelfMove(pick(GLOB.cardinal))
