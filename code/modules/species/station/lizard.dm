/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = SPECIES_UNATHI
	icobase = 'icons/mob/human_races/species/unathi/skin.dmi'
	deform = 'icons/mob/human_races/species/unathi/deformed.dmi'
	husk_icon = 'icons/mob/human_races/species/unathi/husk.dmi'
	preview_icon = 'icons/mob/human_races/species/unathi/preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/unathi_tail.dmi'
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = FALSE
	skin_material =   MATERIAL_SKIN_LIZARD
	icon_template = 'icons/mob/human_races/species/unathi/template.dmi'

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/tail, /datum/unarmed_attack/claws, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Stok"
	darksight_range = 3
	darksight_tint = DARKTINT_MODERATE
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	breath_pressure = 18
	slowdown = 0.5
	brute_mod = 0.8
	flash_mod = 1.2
	blood_volume = 800

	health_hud_intensity = 2
	hunger_factor = DEFAULT_HUNGER_FACTOR * 2

	min_age = 18
	max_age = 260

	body_temperature = null // cold-blooded, implemented the same way nabbers do it

	description = "A heavily reptillian species, Unathi (or 'Sinta as they call themselves) hail from the \
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

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN | SPECIES_NO_ROBOTIC_INTERNAL_ORGANS
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_LIPS | SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR

	flesh_color = "#34af10"

	base_color = "#066000"
	blood_color = "#f24b2e"
	organs_icon = 'icons/mob/human_races/species/unathi/organs.dmi'

	move_trail = /obj/decal/cleanable/blood/tracks/claw

	heat_discomfort_level = 320
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

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_EYES =   /obj/item/organ/internal/eyes/unathi,
		BP_BRAIN =  /obj/item/organ/internal/brain/unathi
		)

	descriptors = list(
		/datum/mob_descriptor/height = 2,
		/datum/mob_descriptor/build = 2
		)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_UNATHI_POLAR,
			CULTURE_UNATHI_DIAMOND_PEAKS,
			CULTURE_UNATHI_DESERT,
			CULTURE_UNATHI_SAVANNAH,
			CULTURE_UNATHI_SALT_SWAMP,
			CULTURE_UNATHI_SPACE,
		),
		TAG_RELIGION =  list(
			RELIGION_UNATHI_STRATAGEM,
			RELIGION_UNATHI_PRECURSOR,
			RELIGION_UNATHI_VINE,
			RELIGION_UNATHI_LIGHTS,
			RELIGION_UNATHI_MARKESHELI,
			RELIGION_UNATHI_ANCESTOR,
			RELIGION_OTHER,
			RELIGION_UNSTATED
		)
	)
	default_cultural_info = list(
		TAG_CULTURE   = CULTURE_UNATHI_POLAR,
		TAG_RELIGION  = RELIGION_OTHER
	)
	pain_emotes_with_pain_level = list(
			list(/singleton/emote/audible/wheeze, /singleton/emote/audible/roar, /singleton/emote/audible/bellow, /singleton/emote/audible/howl) = 80,
			list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/wheeze, /singleton/emote/audible/hiss) = 50,
			list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/hiss) = 20,
		)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_reagent_scale = 5
	exertion_reagent_path = /datum/reagent/lactate
	exertion_emotes_biological = list(
		/singleton/emote/exertion/biological,
		/singleton/emote/exertion/biological/breath,
		/singleton/emote/exertion/biological/pant
	)

	ingest_amount = 20

	traits = list(
		/singleton/trait/boon/filtered_blood = TRAIT_LEVEL_EXISTS,
		/singleton/trait/boon/cast_iron_stomach = TRAIT_LEVEL_EXISTS,
		/singleton/trait/malus/sugar = TRAIT_LEVEL_MAJOR
	)

	footwear_trail_overrides = list(
		/obj/item/clothing = /obj/decal/cleanable/blood/tracks/claw // Needs to apply to both shoes and space suits.
	)

/datum/species/unathi/equip_survival_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/unathi/get_bodytype(mob/living/carbon/human/H)
	return SPECIES_UNATHI
