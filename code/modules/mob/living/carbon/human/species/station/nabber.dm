/datum/species/nabber
	name = SPECIES_NABBER
	name_plural = "Giant Armoured Serpentids"
	blurb = "A species of large invertebrates who, after being discovered by a \
	research company, were taught how to live and work with humans. Standing \
	upwards of nine feet tall, these people have a tendency to terrify \
	those who have not met them before and are rarely trusted by the \
	average person. Even so, they do their jobs well and are thriving in this \
	new environment."

	language = LANGUAGE_NABBER
	default_language = LANGUAGE_NABBER
	assisted_langs = list(LANGUAGE_GALCOM, LANGUAGE_TRADEBAND, LANGUAGE_GUTTER, LANGUAGE_UNATHI, LANGUAGE_SIIK_MAAS, LANGUAGE_SKRELLIAN, LANGUAGE_SOL_COMMON, LANGUAGE_EAL, LANGUAGE_INDEPENDENT)
	additional_langs = list(LANGUAGE_GALCOM)
	name_language = LANGUAGE_NABBER
	min_age = 8
	max_age = 40

	speech_sounds = list('sound/voice/bug.ogg')
	speech_chance = 2

	warning_low_pressure = 50
	hazard_low_pressure = -1

	body_temperature = T0C + 5

	blood_color = "#525252"
	flesh_color = "#525252"

	reagent_tag = IS_NABBER

	icon_template = 'icons/mob/human_races/r_nabber_template.dmi'
	icobase = 'icons/mob/human_races/r_nabber.dmi'
	deform = 'icons/mob/human_races/r_nabber.dmi'

	has_floating_eyes = 1

	darksight = 8
	slowdown = -0.5
	rarity_value = 4
	hud_type = /datum/hud_data/nabber
	total_health = 150
	brute_mod = 0.85
	burn_mod =  1.35
	gluttonous = GLUT_SMALLER
	mob_size = MOB_LARGE
	breath_pressure = 25
	blood_volume = 840
	spawns_with_stack = 0

	flags = NO_SLIP | CAN_NAB | NO_BLOCK
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN

	breathing_organ = BP_TRACH

	var/list/eye_overlays = list()

	has_organ = list(    // which required-organ checks are conducted.
		BP_BRAIN =    /obj/item/organ/internal/brain/nabber,
		BP_EYES =     /obj/item/organ/internal/eyes/nabber,
		BP_TRACH =    /obj/item/organ/internal/lungs/nabber,
		BP_HEART =    /obj/item/organ/internal/heart/nabber,
		BP_LIVER =    /obj/item/organ/internal/liver/nabber,
		BP_PHORON =   /obj/item/organ/internal/phoron,
		BP_VOICE =    /obj/item/organ/internal/voicebox/nabber
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/nabber),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/nabber),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/nabber),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/nabber),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/nabber),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/nabber),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/nabber),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/nabber),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/nabber),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/nabber),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/nabber)
		)

	unarmed_types = list(/datum/unarmed_attack/nabber)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/nab,
		/mob/living/carbon/human/proc/active_camo,
		/mob/living/carbon/human/proc/switch_stance
		)

/datum/species/nabber/get_eyes(var/mob/living/carbon/human/H)
	var/obj/item/organ/internal/eyes/nabber/O = H.internal_organs_by_name[BP_EYES]
	if(!O || !istype(O))
		return

	var/image/eye_overlay = eye_overlays["[O.eyes_shielded] [rgb(O.eye_colour[1], O.eye_colour[2], O.eye_colour[3])]"]
	if(!eye_overlay)
		if(O.eyes_shielded)
			eye_overlay = image('icons/mob/nabber_face.dmi', "eyes_nabber_shielded")
		else
			var/icon/I = new('icons/mob/nabber_face.dmi', "eyes_nabber")
			I.Blend(rgb(O.eye_colour[1], O.eye_colour[2], O.eye_colour[3]), ICON_ADD)
			eye_overlay = image(I)
		eye_overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		eye_overlay.layer = EYE_GLOW_LAYER
		eye_overlays["[O.eyes_shielded] [rgb(O.eye_colour[1], O.eye_colour[2], O.eye_colour[3])]"] = eye_overlay
	return(eye_overlay)

/datum/species/nabber/get_blood_name()
	return "haemolymph"

/datum/species/nabber/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)
	if(!H.handcuffed || H.buckled)
		return ..()
	else
		return 0

/datum/species/nabber/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	if(H.cloaked)
		H.visible_message("<span class='danger'>[H] suddenly appears!</span>")
		H.cloaked = 0

	H.update_icons()

	var/obj/item/organ/internal/B = H.internal_organs_by_name[BP_BRAIN]
	if(istype(B,/obj/item/organ/internal/brain/nabber))
		var/obj/item/organ/internal/brain/nabber/N = B

		tally += N.lowblood_tally

	return tally

/obj/item/grab/nab/special
	type_name = GRAB_NAB_SPECIAL
	start_grab_name = NAB_AGGRESSIVE

/obj/item/grab/nab/special/init()
	..()

	var/armor = affecting.run_armor_check(BP_CHEST, "melee")
	affecting.apply_damage(15, BRUTE, BP_CHEST, armor, DAM_SHARP, "organic punctures")
	affecting.visible_message("<span class='danger'>[assailant]'s spikes dig in painfully!</span>")
	affecting.Stun(10)
