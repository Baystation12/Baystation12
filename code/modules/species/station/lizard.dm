/datum/species/unathi
	name = SPECIES_UNATHI
	name_plural = SPECIES_UNATHI
	icon_template = 'icons/mob/human_races/species/template_tall.dmi'
	icobase = 'icons/mob/human_races/species/unathi/body.dmi'
	deform = 'icons/mob/human_races/species/unathi/deformed_body.dmi'
	husk_icon = 'icons/mob/human_races/species/unathi/husk.dmi'
	preview_icon = 'icons/mob/human_races/species/unathi/preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/unathi_tail.dmi'
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/tail, /datum/unarmed_attack/claws, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp)
	primitive_form = "Stok"
	darksight_range = 3
	darksight_tint = DARKTINT_MODERATE
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	slowdown = 0.5
	radiation_mod = 0.3
	flash_mod = 1.2
	weaken_mod = 1.1
	blood_volume = 800
	natural_armour_values = list(melee = 25, bullet = 15, laser = 10, energy = 0, bomb = 30, bio = 0, rad = 0)
	breath_pressure = 19

	has_organ = list(
		BP_HEAD =     /obj/item/organ/external/head/unathi,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs/unathi,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain/unathi,
		BP_EYES =     /obj/item/organ/internal/eyes,
		BP_MOGENDRIX = /obj/item/organ/internal/mogendrix,
		BP_CARDIOASYLANT = /obj/item/organ/internal/cardioasylant
		)
	
	bioprint_products = list(
		BP_HEART    = list(/obj/item/organ/internal/heart,      45),
		BP_LUNGS    = list(/obj/item/organ/internal/lungs/unathi,      50),
		BP_KIDNEYS  = list(/obj/item/organ/internal/kidneys,    30),
		BP_EYES     = list(/obj/item/organ/internal/eyes,       30),
		BP_LIVER    = list(/obj/item/organ/internal/liver,      35),
		BP_GROIN    = list(/obj/item/organ/external/groin,      80),
		BP_L_ARM    = list(/obj/item/organ/external/arm,        75),
		BP_R_ARM    = list(/obj/item/organ/external/arm/right,  75),
		BP_L_LEG    = list(/obj/item/organ/external/leg,        75),
		BP_R_LEG    = list(/obj/item/organ/external/leg/right,  75),
		BP_L_FOOT   = list(/obj/item/organ/external/foot,       50),
		BP_R_FOOT   = list(/obj/item/organ/external/foot/right, 50),
		BP_L_HAND   = list(/obj/item/organ/external/hand,       50),
		BP_R_HAND   = list(/obj/item/organ/external/hand/right, 50),
		BP_MOGENDRIX = list(/obj/item/organ/internal/mogendrix, 70),
		BP_CARDIOASYLANT = list(/obj/item/organ/internal/cardioasylant, 80)
		)


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

	species_flags = SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34af10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"
	blood_color = "#f24b2e"
	organs_icon = 'icons/mob/human_races/species/unathi/organs.dmi'

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	heat_discomfort_level = 400
	heat_discomfort_strings = list(
		"You feel unpleasantly warm.",
		"You feel the heat sink into your bones.",
		"Your muscles feel tired from the heat."
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

	descriptors = list(
		/datum/mob_descriptor/height = 2,
		/datum/mob_descriptor/build = 2
		)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_UNATHI
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_MOGHES
		),
		TAG_FACTION = list(
			FACTION_UNATHI_POLAR,
			FACTION_UNATHI_DESERT,
			FACTION_UNATHI_SAVANNAH,
			FACTION_UNATHI_DIAMOND_PEAK,
			FACTION_UNATHI_SALT_SWAMP,
			FACTION_NANOTRASEN,
			FACTION_PCRC,
			FACTION_HEPHAESTUS,
			FACTION_CORPORATE,
			FACTION_OTHER
		),
		TAG_RELIGION =  list(
			RELIGION_UNATHI_STRATAGEM,
			RELIGION_UNATHI_PRECURSOR,
			RELIGION_UNATHI_VINE,
			RELIGION_UNATHI_LIGHTS,
			RELIGION_OTHER
		)
	)

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/unathi/proc/handle_sugar(var/mob/living/carbon/human/M, var/datum/reagent/sugar, var/efficiency = 1)
	var/effective_dose = efficiency * M.chem_doses[sugar.type]
	if(effective_dose < 5)
		return
	M.druggy = max(M.druggy, 10)
	M.add_chemical_effect(CE_PULSE, -1)
	if(effective_dose > 15 && prob(7))
		M.emote(pick("twitch", "drool"))
	if(effective_dose > 20 && prob(10))
		M.SelfMove(pick(GLOB.cardinal))

/datum/species/unathi/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_UNATHI