/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = SPECIES_UNATHI
	icon_template = 'icons/mob/human_races/r_template_tall.dmi'
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY

	eye_icon = "eyes_lizard"
	eye_icon_location = 'icons/mob/lizard_face.dmi'

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/tail, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Stok"
	darksight = 3
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	slowdown = 0.5
	brute_mod = 0.8
	blood_volume = 800
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_UNATHI)
	name_language = LANGUAGE_UNATHI
	health_hud_intensity = 2
	hunger_factor = DEFAULT_HUNGER_FACTOR * 3

	min_age = 18
	max_age = 260

	blurb = "A heavily reptillian species, Unathi (or 'Sinta as they call themselves) hail from the \
	Uuosa-Eso system, which roughly translates to 'burning mother'.<br/><br/>Coming from a harsh, radioactive \
	desert planet, they mostly hold ideals of honesty, virtue, martial combat and bravery above all \
	else, frequently even their own lives. They prefer warmer temperatures than most species and \
	their native tongue is a heavy hissing laungage called Sinta'Unathi."

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34af10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"
	blood_color = "#f24b2e"

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)
	breathing_sound = 'sound/voice/lizard.ogg'

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_heal_toggle
		)
/*
	equip_adjust = list(
		slot_glasses_str =   list(NORTH = list("x" = 0, "y" = 2),   EAST = list("x" = 0, "y" = 2),   SOUTH = list("x" = 0, "y" = 2),   WEST = list("x" = 0, "y" = 2)),
		slot_head_str =      list(NORTH = list("x" = 0, "y" = 2),   EAST = list("x" = 0, "y" = 2),   SOUTH = list("x" = 0, "y" = 2),   WEST = list("x" = 0, "y" = 2))
			)

*/
/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/unathi/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.InStasis() || H.stat == DEAD)
		return
	if(H.nutrition < 50)
		H.adjustToxLoss(2,0)
		return
	if(!H.innate_heal)
		return

	//Heals normal damage.
	if(H.getBruteLoss())
		H.adjustBruteLoss(-2 * config.organ_regeneration_multiplier)	//Heal brute better than other ouchies.
		H.nutrition -= 1
	if(H.getFireLoss())
		H.adjustFireLoss(-1 * config.organ_regeneration_multiplier)
		H.nutrition -= 1
	if(H.getToxLoss())
		H.adjustToxLoss(-1 * config.organ_regeneration_multiplier)
		H.nutrition -= 1

	if(prob(5) && H.nutrition > 150 && !H.getBruteLoss() && !H.getFireLoss())
		var/obj/item/organ/external/head/D = H.organs_by_name["head"]
		if (D.disfigured)
			D.disfigured = 0
			H.nutrition -= 20

	if(H.nutrition <= 100)
		return

	for(var/bpart in shuffle(H.internal_organs_by_name - BP_BRAIN))

		var/obj/item/organ/internal/regen_organ = H.internal_organs_by_name[bpart]

		if(regen_organ.robotic >= ORGAN_ROBOT)
			continue
		if(istype(regen_organ))
			if(regen_organ.damage > 0 && !(regen_organ.status & ORGAN_DEAD))
				regen_organ.damage = max(regen_organ.damage - 5, 0)
				H.nutrition -= 5
				if(prob(5))
					to_chat(H, "<span class='warning'>You feel a soothing sensation as your [regen_organ] mends...</span>")

	if(prob(2) && H.nutrition > 150)
		for(var/limb_type in has_limbs)
			var/obj/item/organ/external/E = H.organs_by_name[limb_type]
			if(E && E.organ_tag != BP_HEAD && !E.vital && !E.is_usable())	//Skips heads and vital bits...
				E.removed()			//...because no one wants their head to explode to make way for a new one.
				qdel(E)
				E= null
			if(!E)
				var/list/organ_data = has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/external/O = new limb_path(H)
				organ_data["descriptor"] = O.name
				to_chat(H, "<span class='danger'>With a shower of fresh blood, a new [O.name] forms.</span>")
				H.visible_message("<span class='danger'>With a shower of fresh blood, a length of biomass shoots from [H]'s [O.amputation_point], forming a new [O.name]!</span>")
				H.nutrition -= 50
				var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
				blood_splatter(H,B,1)
				O.set_dna(H.dna)
				H.update_body()
				return
			else
				for(var/datum/wound/W in E.wounds)
					if(W.wound_damage() == 0 && prob(50))
						E.wounds -= W

