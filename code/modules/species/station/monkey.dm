/datum/species/monkey
	name = "Monkey"
	name_plural = "Monkeys"
	description = "Ook."
	codex_description = "Monkeys and other similar creatures tend to be found on science stations and vessels as \
	cheap and disposable test subjects. This, naturally, infuriates animal rights groups."
	hidden_from_codex = FALSE

	icobase =         'icons/mob/human_races/species/monkey/monkey_body.dmi'
	deform =          'icons/mob/human_races/species/monkey/monkey_body.dmi'
	damage_overlays = 'icons/mob/human_races/species/monkey/damage_overlays.dmi'
	damage_mask =     'icons/mob/human_races/species/monkey/damage_mask.dmi'
	blood_mask =      'icons/mob/human_races/species/monkey/blood_mask.dmi'

	greater_form = SPECIES_HUMAN
	mob_size = MOB_SMALL
	show_ssd = null
	health_hud_intensity = 1.75

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	death_message = "lets out a faint chimper as it collapses and stops moving..."
	tail = "chimptail"

	unarmed_types = list(/datum/unarmed_attack/bite, /datum/unarmed_attack/claws, /datum/unarmed_attack/punch)
	inherent_verbs = list(/mob/living/proc/ventcrawl)
	hud_type = /datum/hud_data/monkey
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/monkey

	rarity_value = 0.1
	total_health = 150
	brute_mod = 1.5
	burn_mod = 1.5

	spawn_flags = SPECIES_IS_RESTRICTED

	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = PASS_FLAG_TABLE
	holder_type = /obj/item/weapon/holder
	override_limb_types = list(BP_HEAD = /obj/item/organ/external/head/no_eyes)

	descriptors = list(
		/datum/mob_descriptor/height = -2,
		/datum/mob_descriptor/build = -2
	)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_MONKEY,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

	var/list/no_touchie = list(/obj/item/weapon/mirror,
							   /obj/item/weapon/storage/mirror)

/datum/species/monkey/New()
	equip_adjust = list(
		slot_l_hand_str = list("[NORTH]" = list("x" = 1, "y" = 3), "[EAST]" = list("x" = -3, "y" = 2), "[SOUTH]" = list("x" = -1, "y" = 3), "[WEST]" = list("x" = 3, "y" = 2)),
		slot_r_hand_str = list("[NORTH]" = list("x" = -1, "y" = 3), "[EAST]" = list("x" = 3, "y" = 2), "[SOUTH]" = list("x" = 1, "y" = 3), "[WEST]" = list("x" = -3, "y" = 2)),
		slot_shoes_str = list("[NORTH]" = list("x" = 0, "y" = 7), "[EAST]" = list("x" = -1, "y" = 7), "[SOUTH]" = list("x" = 0, "y" = 7), "[WEST]" = list("x" = 1, "y" = 7)),
		slot_head_str = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -2, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 2, "y" = 0)),
		slot_wear_mask_str = list("[NORTH]" = list("x" = 0, "y" = 0), "[EAST]" = list("x" = -1, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 1, "y" = 0))
	)
	..()

/datum/species/monkey/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		H.SelfMove(pick(GLOB.cardinal))

	var/obj/held = H.get_active_hand()
	if(held && prob(1))
		var/turf/T = get_random_turf_in_range(H, 7, 2)
		if(T)
			if(istype(held, /obj/item/weapon/gun) && prob(80))
				var/obj/item/weapon/gun/G = held
				G.Fire(T, H)
			else
				H.throw_item(T)
		else
			H.unequip_item()
	if(!held && !H.restrained() && prob(5))
		var/list/touchables = list()
		for(var/obj/O in range(1,get_turf(H)))
			if(O.simulated && O.Adjacent(H) && !is_type_in_list(O, no_touchie))
				touchables += O
		if(touchables.len)
			var/obj/touchy = pick(touchables)
			touchy.attack_hand(H)

	if(prob(1))
		H.emote(pick("scratch","jump","roll","tail"))

	if(H.get_shock() && H.shock_stage < 40 && prob(3))
		H.custom_emote("chimpers pitifully")

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote("thrashes in agony")

/datum/species/monkey/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.item_state = lowertext(name)

/datum/species/monkey/alien
	name = "Farwa"
	name_plural = "Farwa"
	health_hud_intensity = 2

	icobase = 'icons/mob/human_races/species/monkey/farwa_body.dmi'
	deform = 'icons/mob/human_races/species/monkey/farwa_body.dmi'

	flesh_color = "#afa59e"
	base_color = "#333333"
	tail = "farwatail"
	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_FARWA,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/skrell
	name = "Neaera"
	name_plural = "Neaera"
	health_hud_intensity = 1.75

	icobase = 'icons/mob/human_races/species/monkey/neaera_body.dmi'
	deform = 'icons/mob/human_races/species/monkey/neaera_body.dmi'

	greater_form = SPECIES_SKRELL
	flesh_color = "#8cd7a3"
	blood_color = "#1d2cbf"
	reagent_tag = IS_SKRELL
	tail = null
	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_NEARA,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)


/datum/species/monkey/unathi
	name = "Stok"
	name_plural = "Stok"
	health_hud_intensity = 1.5

	icobase = 'icons/mob/human_races/species/monkey/stok_body.dmi'
	deform = 'icons/mob/human_races/species/monkey/stok_body.dmi'

	tail = "stoktail"
	greater_form = SPECIES_UNATHI
	flesh_color = "#34af10"
	base_color = "#066000"
	reagent_tag = IS_UNATHI
	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_STOK,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

