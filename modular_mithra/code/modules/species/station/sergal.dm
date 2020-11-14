/datum/species/sergal
	name = SPECIES_SERGAL
	name_plural = SPECIES_SERGAL
	icon_template = 'icons/mob/human_races/species/template.dmi'
	icobase = 'icons/mob/human_races/species/sergal/body.dmi'
	deform = 'icons/mob/human_races/species/sergal/deformed_body.dmi'
	husk_icon = 'icons/mob/human_races/species/sergal/husk.dmi'
	preview_icon = 'icons/mob/human_races/species/sergal/preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	tail = "sergtail"
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/claws, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Monkey"
	darksight_range = 3
	darksight_tint = DARKTINT_MODERATE
	gluttonous = GLUT_TINY
	breath_pressure = 17
	slowdown = -0.25
	brute_mod = 1.20
	burn_mod = 1.20
	blood_volume = 560

	health_hud_intensity = 2
	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.5

	min_age = 18
	max_age = 100

	description = "Sergals are the native race of a planet named Tal, a planet covered by spawling megacities and districts. Run by corporations and criminal cartels, the planet lies in a system that is now controlled by the Sol Central Government. Tal is a protectorate under the SCG, and while the Solarian authority and cartel families attempt to bring Tal in as a proper member world with full citizenship, corporate bodies both on and off-world intend to preserve the status quo of near-unrestricted capitalism."

	cold_level_1 = 260 //Default 260 - Lower is better
	cold_level_2 = 200 //Default 200
	cold_level_3 = 120 //Default 120

	heat_level_1 = 370 //Default 360 - Higher is better
	heat_level_2 = 410 //Default 400
	heat_level_3 = 1010 //Default 1000

	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_ICONBASE
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34af10"

	reagent_tag = IS_SERGAL
	base_color = "#066000"
	blood_color = "#660000"

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	heat_discomfort_level = 320
	heat_discomfort_strings = list(
		"You feel warm.",
		"You feel the heat sink into your bones.",
		"You feel your skin prickle in the heat."
		)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel cold and sluggish.",
		"Your fur bristles against the cold."
		)
	breathing_sound = 'sound/voice/monkey.ogg'

	descriptors = list(
		/datum/mob_descriptor/height = 1,
		/datum/mob_descriptor/build = 1
		)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_SERGAL,
			CULTURE_SYMBIOTIC
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_SERGALTAL
		),
		TAG_FACTION = list(
			FACTION_SERGAL_SHIGU,
			FACTION_SERGAL_GOLD_RING,
			FACTION_SERGAL_REONO
		),
		TAG_RELIGION =  list(
			RELIGION_SERGAL_ANIMISM,
			RELIGION_SERGAL_GOLD_RING,
			RELIGION_OTHER
		)
	)

	pain_emotes_with_pain_level = list(
			list(/decl/emote/audible/wheeze, /decl/emote/audible/howl) = 75,
			list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/wheeze, /decl/emote/audible/hiss) = 50,
			list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/hiss) = 25,
		)

/datum/species/sergal/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/sergal/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_SERGAL
