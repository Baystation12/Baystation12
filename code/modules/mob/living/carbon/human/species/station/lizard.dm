/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = SPECIES_UNATHI
	icon_template = 'icons/mob/human_races/species/template_tall.dmi'
	icobase = 'icons/mob/human_races/species/unathi/body.dmi'
	deform = 'icons/mob/human_races/species/unathi/deformed_body.dmi'
	husk_icon = 'icons/mob/human_races/species/unathi/husk.dmi'
	preview_icon = 'icons/mob/human_races/species/unathi/preview.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/tail, /datum/unarmed_attack/claws, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Stok"
	darksight_range = 3
	darksight_tint = DARKTINT_MODERATE
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	slowdown = 0.5
	brute_mod = 0.8
	flash_mod = 1.2
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
	organs_icon = 'icons/mob/human_races/species/unathi/organs.dmi'

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

	base_auras = list(
		/obj/aura/regenerating/human/unathi
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/diona_heal_toggle
		)

	prone_overlay_offset = list(-4, -4)

	override_limb_types = list(BP_HEAD = /obj/item/organ/external/head/unathi)

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
