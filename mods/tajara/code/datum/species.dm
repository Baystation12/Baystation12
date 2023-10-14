/datum/species/tajaran
	name = SPECIES_TAJARA
	name_plural = "Tajaran"
	icobase = 'mods/tajara/icons/tajara_body/body.dmi'
	deform =  'mods/tajara/icons/tajara_body/deformed_body.dmi'
	preview_icon = 'mods/tajara/icons/tajara_body/preview.dmi'
	tail = "tajtail"
	tail_animation = 'mods/tajara/icons/tajara_body/tail.dmi'
	default_head_hair_style = "Tajaran Ears"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp)




	darksight_range = 7
	darksight_tint = DARKTINT_GOOD
	slowdown = -0.5
	brute_mod = 1.15
	burn_mod =  1.15
	flash_mod = 1.5
	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.5

	gluttonous = GLUT_TINY
	hidden_from_codex = FALSE
	health_hud_intensity = 1.75

	min_age = 19
	max_age = 140 //good medicine?

	description = "The Tajaran are a species of furred mammalian bipeds hailing from the chilly planet of Ahdomai \
	in the Zamsiin-lr system. They are a naturally superstitious species, with the new generations growing up with tales \
	of the heroic struggles of their forebears against the Overseers. This spirit has led them forward to the \
	reconstruction and advancement of their society to what they are today. Their pride for the struggles they \
	went through is heavily tied to their spiritual beliefs. Recent discoveries have jumpstarted the progression \
	of highly advanced cybernetic technology, causing a culture shock within Tajaran society."

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
		)
	cold_discomfort_level = 230

	primitive_form = "Farwa"


	default_emotes = list(
		/singleton/emote/human/swish,
		/singleton/emote/human/wag,
		/singleton/emote/human/sway,
		/singleton/emote/human/qwag,
		/singleton/emote/human/fastsway,
		/singleton/emote/human/swag,
		/singleton/emote/human/stopsway
		)

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_LIPS | SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR

	flesh_color = "#afa59e"
	base_color = "#333333"
	blood_color = "#862a51"
	organs_icon = 'mods/tajara/icons/tajara_body/organs.dmi'

	move_trail = /obj/decal/cleanable/blood/tracks/paw
/*
	base_auras = list(
		/obj/aura/speed/bio/tajaran
		)
	inherent_verbs = list(
		/mob/living/carbon/human/proc/toggle_sprint
		)
*/
	sexybits_location = BP_GROIN

	available_cultural_info = list(
		TAG_CULTURE =   list(
			CULTURE_TAJARAN,
			CULTURE_HUMAN,
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_LUNARICH,
			CULTURE_HUMAN_VENUSIAN,
			CULTURE_HUMAN_VENUSLOW,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_OTHER
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_AHDOMAI,
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_HELIOS,
			HOME_SYSTEM_GAIA,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_TAJARAN_HADII,
			FACTION_TAJARAN_KAYTAM,
			FACTION_TAJARAN_KAYTAM_KSD,
			FACTION_TAJARAN_SHISHI,
			FACTION_TAJARAN_JAR,
			FACTION_TAJARAN_NAZKIIN,
			FACTION_TAJARAN_OTHER,
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_HEPHAESTUS,
			FACTION_XYNERGY,
			FACTION_EXPEDITIONARY,
			FACTION_PCRC,
			FACTION_CORPORATE,
			FACTION_DAIS,
			FACTION_SAARE,
			FACTION_OTHER
		),
		TAG_RELIGION =  list(
			RELIGION_SPIRITUALISM,
			RELIGION_JUDAISM,
			RELIGION_HINDUISM,
			RELIGION_BUDDHISM,
			RELIGION_ISLAM,
			RELIGION_CHRISTIANITY,
			RELIGION_AGNOSTICISM,
			RELIGION_DEISM,
			RELIGION_THELEMA,
			RELIGION_ATHEISM,
			RELIGION_OTHER
		)
	)

/obj/item/organ/internal/eyes/taj
	name = "tajara eyes"


/datum/species/tajaran/equip_survival_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/tajblind(H),slot_glasses)

// human_species part
/mob/living/carbon/human/tajaran/Initialize(mapload)
	head_hair_style = "Tajaran Ears"
	. = ..(mapload, SPECIES_TAJARA)

/mob/living/carbon/human/farwa/Initialize(mapload)
	. = ..(mapload, "Farwa")
