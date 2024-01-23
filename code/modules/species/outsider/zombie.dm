
//// Zombie Defines

#define SPECIES_ZOMBIE "Zombie"
#define LANGUAGE_ZOMBIE "Zombie"
#define ANTAG_ZOMBIE "Zombie"

//// Zombie Globals

GLOBAL_LIST_INIT(zombie_messages, list(
	"stage1" = list(
		"You feel uncomfortably warm.",
		"You feel rather feverish.",
		"Your throat is extremely dry...",
		"Your muscles cramp...",
		"You feel dizzy.",
		"You feel fatigued.",
		"You feel light-headed."
	),
	"stage2" = list(
		"You feel something under your skin!",
		"Mucus runs down the back of your throat.",
		"Your muscles burn.",
		"Your skin itches.",
		"Your bones ache.",
		"Sweat runs down the side of your neck.",
		"Your heart races."
	),
	"stage3" = list(
		"Your head feels like it's splitting open!",
		"Your skin is peeling away!",
		"Your body stings all over!",
		"It feels like your insides are squirming!",
		"You're in agony!"
	)
))


GLOBAL_LIST_INIT(zombie_species, list(\
	SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_VOX,\
	SPECIES_SKRELL, SPECIES_PROMETHEAN, SPECIES_ALIEN, SPECIES_YEOSA, SPECIES_VATGROWN,\
	SPECIES_SPACER, SPECIES_TRITONIAN, SPECIES_GRAVWORLDER, SPECIES_MULE, SPECIES_MONKEY,\
	SPECIES_FARWA, SPECIES_NEAERA, SPECIES_STOK
))


//// Zombie Types

/datum/species/zombie
	name = "Zombie"
	name_plural = "Zombies"
	blood_color = "#411111"
	preview_icon = null
	death_message = "writhes and twitches before falling motionless."
	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SCAN
	spawn_flags = SPECIES_IS_RESTRICTED
	vision_flags = SEE_SELF | SEE_MOBS
	brute_mod = 1.0
	burn_mod = 1.5 //Vulnerable to fire
	oxy_mod = 0.0
	stun_mod = 0.2
	weaken_mod = 0.3
	paralysis_mod = 0.2
	show_ssd = null //No SSD message so NPC logic can take over
	show_coma = null
	warning_low_pressure = 0
	hazard_low_pressure = 0
	body_temperature = null
	cold_level_1 = -1
	cold_level_2 = -1
	cold_level_3 = -1
	hidden_from_codex = TRUE
	unarmed_types = list(/datum/unarmed_attack/bite/sharp/zombie)
	move_intents = list(/singleton/move_intent/zombie)
	var/heal_rate = 0.5 // Regen.

/datum/species/zombie/handle_post_spawn(mob/living/carbon/human/H)
	H.mutations |= MUTATION_CLUMSY
	H.mutations |= MUTATION_FERAL
	H.mutations |= mNobreath //Byond doesn't like adding them all in one OR statement :(
	H.verbs += /mob/living/carbon/proc/consume
	H.a_intent = "harm"
	H.move_intents = list(new /singleton/move_intent/zombie) //Zooming days are over
	H.move_intent = new /singleton/move_intent/zombie
	H.default_run_intent = H.move_intent
	H.default_walk_intent = H.move_intent

	H.set_sight(H.sight | SEE_MOBS)

	H.languages = list()
	H.add_language(LANGUAGE_ZOMBIE)
	H.faction = "zombies"

	H.ai_holder = new /datum/ai_holder/human/zombie (H)
	H.say_list_type = /datum/say_list/zombie
	H.say_list = new /datum/say_list/zombie (H)
	H.possession_candidate = TRUE

	H.sleeping = 0
	H.resting = 0
	H.weakened = 0
	H.dizziness = 0

	for (var/obj/item/organ/organ in (H.organs + H.internal_organs))
		if (organ.name == "brain")
			continue
		organ.vital = 0
		if (!BP_IS_ROBOTIC(organ))
			organ.min_broken_damage = organ.max_damage

	H.stat = CONSCIOUS

	H.remove_from_mob(H.gloves)
	H.remove_from_mob(H.head) // Remove helmet so headshots aren't impossible
	H.remove_from_mob(H.glasses)
	H.remove_from_mob(H.wear_mask)

	..()

/datum/species/zombie/handle_environment_special(mob/living/carbon/human/H)
	if (H.stat == CONSCIOUS)
		if (prob(5))
			playsound(H.loc, 'sound/hallucinations/far_noise.ogg', 15, 1)
		else if (prob(5))
			playsound(H.loc, 'sound/hallucinations/veryfar_noise.ogg', 15, 1)
		else if (prob(5))
			playsound(H.loc, 'sound/hallucinations/wail.ogg', 15, 1)

	if (H.stat != DEAD)
		for(var/obj/item/organ/organ in (H.organs + H.internal_organs))
			if (organ.damage > 0)
				organ.heal_damage(heal_rate, heal_rate, 1)
		if (H.getToxLoss())
			H.adjustToxLoss(-heal_rate)
		if (prob(5))
			H.resuscitate()
		H.vessel.add_reagent(/datum/reagent/blood, min(heal_rate * 20, blood_volume - H.vessel.total_volume))

	else
		var/list/victims = ohearers(rand(1, 2), H)
		for(var/mob/living/carbon/human/M in victims) // Post-mortem infection
			if (H == M || M.is_zombie())
				continue
			if (M.isSynthetic() || M.is_species(SPECIES_DIONA) || !(M.species.name in GLOB.zombie_species))
				continue
			if (M.wear_mask && (M.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT)) // If they're protected by a mask
				continue
			if (M.head && (M.head.item_flags & ITEM_FLAG_AIRTIGHT)) // If they're protected by a helmet
				continue

			var/vuln = 1 - M.get_blocked_ratio(BP_HEAD, DAMAGE_TOXIN, damage_flags = DAMAGE_FLAG_BIO) // Are they protected by hazmat clothing?
			if (vuln > 0.10 && prob(8))
				M.reagents.add_reagent(/datum/reagent/zombie, 0.5) // Infect 'em

/datum/species/zombie/handle_death(mob/living/carbon/human/H)
	playsound(H, 'sound/hallucinations/wail.ogg', 30, 1)
	return TRUE

/datum/species/zombie/get_blood_name()
	return "decaying blood"

/datum/species/zombie/has_fine_manipulation(mob/living/carbon/human/H)
	return (MUTATION_CLUMSY in H.mutations) ? FALSE : TRUE

/singleton/move_intent/zombie
	name = "Shuffle"
	flags = MOVE_INTENT_DELIBERATE
	hud_icon_state = "creeping"
	move_delay = 10

/datum/say_list/zombie
	emote_hear = list("wails!","groans!")

/datum/ai_holder/human/zombie
	hostile = TRUE
	destructive = TRUE
	can_flee = FALSE
	mauling = TRUE
	handle_corpse = TRUE
	use_astar = TRUE
	wander_when_pulled = TRUE
	base_wander_delay = 2
	wander_chance = 50
	vision_range = 15
	speak_chance = 5
	lose_target_timeout = 90 SECONDS

	valid_obstacles_by_priority = list(
		/obj/structure/closet,
		/obj/structure/table,
		/obj/structure/grille,
		/obj/structure/barricade,
		/obj/structure/wall_frame,
		/obj/structure/railing,
		/obj/structure/girder,
		/turf/simulated/wall
	)

/datum/ai_holder/human/zombie/can_pursue(atom/movable/target)
	if (!istype(target, /mob/living))
		return FALSE

	if (!..())
		return FALSE

	var/mob/living/target_living = target

	if (!istype(target_living, /mob/living/carbon/human)) //Ignore Diona and unconscious non-humans
		if (istype(target_living, /mob/living/carbon/alien/diona))
			return FALSE
		if (target_living.stat != CONSCIOUS)
			return FALSE

	var/mob/living/carbon/human/target_human = target
	if (target_human.is_zombie() || target_human.is_species(SPECIES_DIONA))
		return FALSE

	if (target_human.stat != CONSCIOUS && (target_human.isSynthetic() || (MUTATION_SKELETON in target_human.mutations) || !(target_human.species.name in GLOB.zombie_species)))
		return FALSE

	if (is_being_consumed(target_human))
		return FALSE

	return TRUE

/datum/ai_holder/human/zombie/proc/is_consumable(mob/living/target_living)
	if (!istype(target_living, /mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/target_human = target_living
	if (target_human.isSynthetic())
		return FALSE

	if (!(target_human.species.name in GLOB.zombie_species))
		return FALSE

	return can_pursue(target_living)

/datum/ai_holder/human/zombie/proc/is_being_consumed(mob/living/target_living)
	//Will exclude consumption candidates if there's another zombie on top of them
	var/turf/target_turf = get_turf(target_living)
	if (!target_turf)
		return FALSE
	for (var/mob/living/carbon/human/consumer in target_turf.contents)
		if (consumer != holder && consumer.stat == CONSCIOUS && consumer.is_zombie())
			return TRUE
	return FALSE

/datum/ai_holder/human/zombie/pick_target(list/targets)
	// If there are any conscious mobs, pick them
	// If not, pick the closest consumable mob, which isn't being consumed already
	var/lowest_distance = 1e6 //fakely far
	var/atom/movable/new_target = null
	var/conscious_target = FALSE
	for (var/atom/movable/possible_target in targets)
		if (!istype(possible_target, /mob/living))
			continue
		var/mob/living/possible_target_living = possible_target
		var/current_distance = get_dist(holder, possible_target)
		if (is_being_consumed(possible_target_living))
			continue
		if (possible_target_living.stat == CONSCIOUS)
			if (!conscious_target) // Prioritize a conscious target over an unconscious one, regardless of distance
				lowest_distance = current_distance
				new_target = possible_target
			conscious_target = TRUE
		else if (conscious_target || !is_consumable(possible_target_living))
			continue
		if (current_distance < lowest_distance)
			lowest_distance = current_distance
			new_target = possible_target
	return new_target

/datum/ai_holder/human/zombie/post_melee_attack()
	if (istype(target, /mob/living))
		var/mob/living/target_living = target
		if (target_living.lying && is_consumable(target_living))
			if (find_target() != target) // In case we need to re-prioritize
				return
			if (holder.loc == target.loc)
				var/mob/living/carbon/human/holder_human = holder
				holder_human.consume()
			else
				holder.IMove(get_step_towards(holder, target))

/datum/ai_holder/human/zombie/pry_door(obj/machinery/door/door)
	if (!door.operable())
		door.attack_hand(holder)
		return TRUE
	return FALSE

/datum/ai_holder/human/zombie/handle_special_strategical()
	if (!check_listeners())
		return

	if (holder.restrained() && prob(8))
		holder.custom_emote(AUDIBLE_MESSAGE,"thrashes and writhes!")
	else if (prob(speak_chance))
		emote_random()

/datum/language/zombie
	name = LANGUAGE_ZOMBIE
	desc = "A crude form of feral communication utilized by the shuffling horrors. The living only hear guttural wails of agony."
	colour = "cult"
	key = "a"
	speech_verb = "growls"
	exclaim_verb = "wails"
	partial_understanding = list(
		LANGUAGE_HUMAN_EURO = 20,
		LANGUAGE_SPACER = 30
	)
	syllables = list("mhh..", "grr..", "nnh..")
	shorthand = "ZM"
	hidden_from_codex = TRUE


/datum/unarmed_attack/bite/sharp/zombie
	attack_verb = list("slashed", "sunk their teeth into", "bit", "mauled")
	delay = 12

/datum/unarmed_attack/bite/sharp/zombie/is_usable(mob/living/carbon/human/user, mob/living/carbon/human/target, zone)
	. = ..()
	if (!.)
		return FALSE
	if (istype(target, /mob/living/carbon/human) && target.is_zombie())
		to_chat(usr, SPAN_WARNING("They don't look very appetizing!"))
		return FALSE
	return TRUE

/datum/unarmed_attack/bite/sharp/zombie/apply_effects(mob/living/carbon/human/user, mob/living/carbon/human/target, attack_damage, zone)
	..()

	admin_attack_log(user, target, "Bit their victim.", "Was bitten.", "bit")
	if (!istype(target, /mob/living/carbon/human) || !(target.species.name in GLOB.zombie_species) || target.is_species(SPECIES_DIONA) || target.isSynthetic()) //No need to check infection for FBPs
		return

	target.adjustHalLoss(12) //To help bring down targets in voidsuits
	var/vuln = 1 - target.get_blocked_ratio(zone, DAMAGE_TOXIN, damage_flags = DAMAGE_FLAG_BIO) //Are they protected from bites?
	if (vuln > 0.05)
		if (prob(vuln * 100)) //Protective infection chance
			if (prob(min(100 - target.get_blocked_ratio(zone, DAMAGE_BRUTE) * 100, 30))) //General infection chance
				target.reagents.add_reagent(/datum/reagent/zombie, 1) //Infect 'em


/datum/reagent/zombie
	name = "Liquid Corruption"
	description = "A filthy, oily substance which slowly churns of its own accord."
	taste_description = "decaying blood"
	color = "#411111"
	taste_mult = 5
	metabolism = REM
	overdose = 200
	filter_mod = 0.3
	hidden_from_codex = TRUE
	heating_products = null
	heating_point = null
	should_admin_log = TRUE

/datum/reagent/zombie/affect_blood(mob/living/carbon/M, removed)
	if (!ishuman(M))
		return
	var/mob/living/carbon/human/H = M

	if (!(H.species.name in GLOB.zombie_species) || H.is_species(SPECIES_DIONA) || H.isSynthetic())
		remove_self(volume)
		return
	var/true_dose = H.chem_doses[type] + volume

	if (true_dose >= 30)
		if (M.getBrainLoss() > 140)
			H.zombify()
		if (prob(2))
			to_chat(M, SPAN_WARNING(SPAN_SIZE(rand(1,2), pick(GLOB.zombie_messages["stage1"]))))

	if (true_dose >= 60)
		M.bodytemperature += 7.5
		if (prob(3))
			to_chat(M, SPAN_WARNING(FONT_NORMAL(pick(GLOB.zombie_messages["stage1"]))))

	if (true_dose >= 90)
		M.adjustBruteLoss(rand(1, 2))
		M.add_chemical_effect(CE_MIND, -2)
		M.hallucination(50, min(true_dose / 2, 50))
		if (M.getBrainLoss() < 75)
			M.adjustBrainLoss(rand(1, 2))
		if (prob(1))
			M.seizure()
			M.adjustBrainLoss(rand(12, 24))
		if (prob(5))
			to_chat(M, SPAN_DANGER(SPAN_SIZE(rand(2,3), pick(GLOB.zombie_messages["stage2"]))))
		M.bodytemperature += 9

	if (true_dose >= 120)
		M.adjustHalLoss(3)
		M.make_dizzy(10)
		var/obj/item/organ/internal = pick(M.internal_organs)
		internal.take_general_damage(rand(1, 3))
		if (prob(8))
			to_chat(M, SPAN_DANGER(SPAN_SIZE(rand(3,4), pick(GLOB.zombie_messages["stage3"]))))

	if (true_dose >= 140)
		if (prob(3))
			H.zombify()

	M.reagents.add_reagent(/datum/reagent/zombie, Frand(0.1, 1))

/datum/reagent/zombie/affect_touch(mob/living/carbon/M, removed)
	affect_blood(M, removed * 0.5)


//// Zombie Procs


/mob/living/carbon/human/proc/zombify()
	if (!(species.name in GLOB.zombie_species) || is_species(SPECIES_DIONA) || is_zombie() || isSynthetic())
		return

	adjustHalLoss(100)
	adjustBruteLoss(50)
	make_jittery(300)

	var/turf/T = get_turf(src)
	new /obj/decal/cleanable/vomit(T)
	playsound(T, 'sound/effects/splat.ogg', 20, 1)

	var/obj/item/held_l = get_equipped_item(slot_l_hand)
	var/obj/item/held_r = get_equipped_item(slot_r_hand)
	if(held_l)
		drop_from_inventory(held_l)
	if(held_r)
		drop_from_inventory(held_r)
	sleep(150)

	addtimer(new Callback(src, .proc/transform_zombie), 20)

/mob/living/carbon/human/proc/transform_zombie()
	if (QDELETED(src))
		return

	if (is_zombie()) //Check again otherwise Consume can run this twice at once
		return

	var/head_hair_old = head_hair_style
	var/facial_hair_old = facial_hair_style

	rejuvenate()

	hallucination_power = 0
	hallucination_duration = 0
	if (should_have_organ(BP_HEART))
		vessel.add_reagent(/datum/reagent/blood, species.blood_volume - vessel.total_volume)

	adjustBruteLoss(100)
	resuscitate()
	set_stat(CONSCIOUS)

	if (skillset && skillset.skill_list)
		skillset.skill_list = list()
		for(var/singleton/hierarchy/skill/S in GLOB.skills) //Only want trained CQC and athletics
			skillset.skill_list[S.type] = SKILL_UNSKILLED
		skillset.skill_list[SKILL_HAULING] = SKILL_TRAINED
		skillset.skill_list[SKILL_COMBAT] = SKILL_EXPERIENCED
		skillset.on_levels_change()

	if (mind)
		if (mind.special_role == ANTAG_ZOMBIE)
			return
		mind.special_role = ANTAG_ZOMBIE

	species.handle_pre_spawn(src)
	species = all_species[SPECIES_ZOMBIE]
	species.handle_post_spawn(src)

	if(!(MUTATION_HUSK in mutations))
		mutations.Add(MUTATION_HUSK)
		for(var/obj/item/organ/external/E in organs)
			E.status |= ORGAN_DISFIGURED

	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	head?.glowing_eyes = TRUE
	eye_color = "#662300"
	update_eyes()

	head_hair_style = head_hair_old // Stop us going bald when we're husked
	facial_hair_style = facial_hair_old
	regenerate_icons()

	visible_message(SPAN_DANGER("\The [src]'s skin decays before your very eyes!"), SPAN_DANGER("Your entire body is ripe with pain as it is consumed down to flesh and bones. You ... hunger. Not only for flesh, but to spread this gift. Use Abilities -> Consume to infect and feed upon your prey."))
	log_admin("[key_name(src)] has transformed into a zombie!")

	playsound(get_turf(src), 'sound/hallucinations/wail.ogg', 25, 1)

/mob/living/carbon/human/proc/transform_zombie_smart()
	if (!is_zombie())
		transform_zombie()

	mutations.Remove(MUTATION_CLUMSY)

	eye_color = "#0060e1"
	update_eyes()

/mob/living/carbon/proc/consume()
	set name = "Consume"
	set desc = "Regain life and infect others by feeding upon them."
	set category = "Abilities"

	if (last_special > world.time)
		to_chat(src, SPAN_WARNING("You aren't ready to do that! Wait [round(last_special - world.time) / 10] seconds."))
		return

	var/mob/living/carbon/human/target
	var/list/victims = list()
	for (var/mob/living/carbon/human/L in get_turf(src))
		if (L != src && (L.lying || L.stat == DEAD))
			if (L.is_zombie())
				to_chat(src, SPAN_WARNING("\The [L] isn't fresh anymore!"))
				continue
			if (!(L.species.name in GLOB.zombie_species) || L.is_species(SPECIES_DIONA) || L.isSynthetic())
				to_chat(src, SPAN_WARNING("You'd break your teeth on \the [L]!"))
				continue
			victims += L

	if (!length(victims))
		to_chat(src, SPAN_WARNING("No valid targets nearby!"))
		return
	if (client)
		if (length(victims) == 1) //No need to choose
			target = victims[1]
		else
			target = input("Who would you like to consume?") as null | anything in victims
	else //NPCs
		if (length(victims) > 0)
			target = victims[1]

	if (!target)
		to_chat(src, SPAN_WARNING("You aren't on top of a victim!"))
		return
	if (get_turf(src) != get_turf(target) || !(target.lying || target.stat == DEAD))
		to_chat(src, SPAN_WARNING("You're no longer on top of \the [target]!"))
		return

	last_special = world.time + 5 SECONDS

	visible_message(SPAN_DANGER("\The [src] hunkers down over \the [target], tearing into their flesh."))
	playsound(loc, 'sound/effects/bonebreak3.ogg', 20, 1)

	target.adjustHalLoss(25)

	if (do_after(src, 5 SECONDS, target, DO_DEFAULT | DO_USER_UNIQUE_ACT, INCAPACITATION_KNOCKOUT))
		admin_attack_log(src, target, "Consumed their victim.", "Was consumed.", "consumed")

		if (!target.lying && target.stat != DEAD) //Check victims are still prone
			return

		target.reagents.add_reagent(/datum/reagent/zombie, 35) //Just in case they haven't been infected already
		if (target.getBruteLoss() > target.maxHealth * 1.5)
			to_chat(src,SPAN_WARNING("You've scraped \the [target] down to the bones already!."))
			if (target.stat != DEAD)
				target.zombify()
			else if (!(MUTATION_SKELETON in target.mutations))
				if (istype(target, /mob/living/carbon/human/monkey))
					target.gib()
				else
					for (var/obj/item/clothing/clothing in target.contents)
						if (!istype(clothing, /obj/item/clothing/under) && !istype(clothing, /obj/item/clothing/suit))
							target.remove_from_mob(clothing)
					target.ChangeToSkeleton()
					target.adjustBruteLoss(500)
				to_chat(src, SPAN_DANGER("You shred and rip apart \the [target]'s remains!."))
				playsound(loc, 'sound/effects/splat.ogg', 40, 1)
			return

		to_chat(target,SPAN_DANGER("\The [src] scrapes your flesh from your bones!"))
		to_chat(src,SPAN_DANGER("You feed hungrily off \the [target]'s flesh."))

		if (target.is_zombie()) //Just in case they turn whilst being eaten
			return

		target.adjustHalLoss(25)
		target.apply_damage(rand(50, 60), DAMAGE_BRUTE, BP_CHEST)
		target.adjustBruteLoss(20)
		target.update_surgery() //Update broken ribcage sprites etc.

		adjust_nutrition(40)
		adjustToxLoss(-20)
		for(var/obj/item/organ/organ in (organs + internal_organs))
			if (organ.damage > 0)
				organ.heal_damage(10, 10, 1)

		playsound(loc, 'sound/effects/splat.ogg', 20, 1)
		new /obj/decal/cleanable/blood/splatter(get_turf(src), target.species.blood_color)
		if (target.getBruteLoss() > target.maxHealth*0.75)
			if (prob(50))
				gibs(get_turf(src), target.dna)
				visible_message(SPAN_DANGER("\The [src] tears out \the [target]'s insides!"))
	else
		visible_message(SPAN_WARNING("\The [src] leaves their meal for later."))

/mob/observer/ghost/verb/join_as_zombie()
	set name = "Join as Zombie"
	set category = "Ghost"

	if(!config.ghosts_can_possess_zombies)
		to_chat(src, SPAN_WARNING("Possessing zombies is currently disabled."))
		return

	if(!MayRespawn(1, ANIMAL_SPAWN_DELAY))
		return

	for (var/mob/living/carbon/human/candidate)
		if (candidate.is_zombie() && !candidate.ckey && candidate.stat == CONSCIOUS)
			var/response = alert(src, "Are you sure you want to become a zombie?","Confirm","Yes","No")
			if(response != "Yes")
				return
			candidate.do_possession(src)

	to_chat(src, SPAN_WARNING("There are no zombies available at the moment."))


//// Zombie Atoms


/obj/item/reagent_containers/syringe/zombie
	name = "Syringe (unknown serum)"
	desc = "Contains a strange, crimson substance."

/obj/item/reagent_containers/syringe/zombie/Initialize()
	..()
	reagents.add_reagent(/datum/reagent/zombie, 15)
	mode = SYRINGE_INJECT
	update_icon()

/mob/living/proc/is_zombie()
	return FALSE

/mob/living/carbon/human/is_zombie()
	return is_species(SPECIES_ZOMBIE)

/mob/living/carbon/human/zombie
	/// List (`/singleton/hierarchy/outfit`) - List of possible outfits the zombie can spawn as. Randomly chosen during init.
	var/static/list/spawn_outfit_options = list(
		/singleton/hierarchy/outfit/job/science/scientist,
		/singleton/hierarchy/outfit/job/science/xenobiologist,
		/singleton/hierarchy/outfit/job/science/rd,
		/singleton/hierarchy/outfit/job/engineering/chief_engineer,
		/singleton/hierarchy/outfit/job/engineering/engineer,
		/singleton/hierarchy/outfit/job/engineering/atmos,
		/singleton/hierarchy/outfit/job/cargo/qm,
		/singleton/hierarchy/outfit/job/cargo/cargo_tech,
		/singleton/hierarchy/outfit/job/cargo/mining,
		/singleton/hierarchy/outfit/job/medical/cmo,
		/singleton/hierarchy/outfit/job/medical/doctor,
		/singleton/hierarchy/outfit/job/medical/doctor/emergency_physician,
		/singleton/hierarchy/outfit/job/medical/doctor/surgeon,
		/singleton/hierarchy/outfit/job/medical/doctor/virologist,
		/singleton/hierarchy/outfit/job/medical/doctor/nurse,
		/singleton/hierarchy/outfit/job/medical/geneticist,
		/singleton/hierarchy/outfit/job/medical/psychiatrist,
		/singleton/hierarchy/outfit/job/medical/paramedic,
		/singleton/hierarchy/outfit/job/medical/paramedic/emt,
		/singleton/hierarchy/outfit/job/medical/chemist,
		/singleton/hierarchy/outfit/job/security/officer,
		/singleton/hierarchy/outfit/job/assistant,
		/singleton/hierarchy/outfit/job/service/chef,
		/singleton/hierarchy/outfit/job/service/gardener,
		/singleton/hierarchy/outfit/job/service/janitor,
		/singleton/hierarchy/outfit/job/chaplain
		)

/mob/living/carbon/human/zombie/Initialize(mapload)
	. = ..(mapload, SPECIES_ZOMBIE)

	var/singleton/cultural_info/culture = get_cultural_value(TAG_CULTURE)
	SetName(culture.get_random_name(gender))
	real_name = name
	add_language(LANGUAGE_ZOMBIE)

	var/obj/item/organ/external/head/head = organs_by_name[BP_HEAD]
	head?.glowing_eyes = TRUE
	eye_color = "#662300"
	update_eyes()

	if (skillset && skillset.skill_list)
		skillset.skill_list = list()
		for(var/singleton/hierarchy/skill/S in GLOB.skills) //Only want trained CQC and athletics
			skillset.skill_list[S.type] = SKILL_UNSKILLED
		skillset.skill_list[SKILL_HAULING] = SKILL_TRAINED
		skillset.skill_list[SKILL_COMBAT] = SKILL_EXPERIENCED
		skillset.on_levels_change()

	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/zombie/LateInitialize(mapload)
	var/singleton/hierarchy/outfit/outfit = pick(spawn_outfit_options)
	outfit = outfit_by_type(outfit)
	outfit.equip(src, OUTFIT_ADJUSTMENT_ALL_SKIPS)

	if (wear_id)
		qdel(wear_id)
	if (l_hand)
		qdel(l_hand)
	if (r_hand)
		qdel(r_hand)
	if (wear_mask)
		qdel(wear_mask)
	if (back)
		qdel(back)

	ChangeToHusk()
	transform_zombie()
