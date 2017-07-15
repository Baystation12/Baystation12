/datum/species/monkey
	name = "Monkey"
	name_plural = "Monkeys"
	blurb = "Ook."

	icobase = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	deform = 'icons/mob/human_races/monkeys/r_monkey.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_monkey.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_monkey.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_monkey.dmi'
	language = null
	default_language = "Chimpanzee"
	greater_form = SPECIES_HUMAN
	mob_size = MOB_SMALL
	show_ssd = null
	health_hud_intensity = 1.75

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	death_message = "lets out a faint chimper as it collapses and stops moving..."
	tail = "chimptail"

	unarmed_types = list(/datum/unarmed_attack/bite, /datum/unarmed_attack/claws)
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

	pass_flags = PASSTABLE
	holder_type = /obj/item/weapon/holder
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/no_eyes),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/datum/species/monkey/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(GLOB.cardinal))
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

/datum/species/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/species/monkey/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.item_state = lowertext(name)

/datum/species/monkey/tajaran
	name = "Farwa"
	name_plural = "Farwa"
	health_hud_intensity = 2

	icobase = 'icons/mob/human_races/monkeys/r_farwa.dmi'
	deform = 'icons/mob/human_races/monkeys/r_farwa.dmi'

	greater_form = "Tajaran"
	default_language = "Farwa"
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"

/datum/species/monkey/skrell
	name = "Neaera"
	name_plural = "Neaera"
	health_hud_intensity = 1.75

	icobase = 'icons/mob/human_races/monkeys/r_neaera.dmi'
	deform = 'icons/mob/human_races/monkeys/r_neaera.dmi'

	greater_form = SPECIES_SKRELL
	default_language = "Neaera"
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = IS_SKRELL
	tail = null

/datum/species/monkey/unathi
	name = "Stok"
	name_plural = "Stok"
	health_hud_intensity = 1.5

	icobase = 'icons/mob/human_races/monkeys/r_stok.dmi'
	deform = 'icons/mob/human_races/monkeys/r_stok.dmi'

	tail = "stoktail"
	greater_form = SPECIES_UNATHI
	default_language = "Stok"
	flesh_color = "#34AF10"
	base_color = "#066000"
	reagent_tag = IS_UNATHI
