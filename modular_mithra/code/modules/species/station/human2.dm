/datum/species/customhuman
	name = SPECIES_HUMAN2
	name_plural = SPECIES_HUMAN2
	icobase = 'modular_mithra/icons/mob/human_races/species/custom_human/body.dmi'
	deform = 'modular_mithra/icons/mob/human_races/species/custom_human/deformed_body.dmi'
	husk_icon = 'modular_mithra/icons/mob/human_races/species/custom_human/husk.dmi'
//	preview_icon = 'modular_mithra/icons/mob/human_races/species/custom_human/preview.dmi' No preview icon yet. I dunno if this breaks things - YES IT DOES.
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = TRUE

	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_ICONBASE //Used only for custom species. Should not be selectable as a race by itself

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)

	description = "If you see this, you're either an admin or something has gone wrong"

	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	sexybits_location = BP_GROIN //this is possibly my favorite variable just because of how out of place it is.


	available_cultural_info = list( //Shouldn't ultimatley matter as this race will only be used for custom species
		TAG_CULTURE = list(
			CULTURE_HUMAN,
			CULTURE_HUMAN_VATGROWN,
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_LUNARICH,
			CULTURE_HUMAN_VENUSIAN,
			CULTURE_HUMAN_VENUSLOW,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_PLUTO,
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_CONFED,
			CULTURE_HUMAN_OTHER,
			CULTURE_SKRELL_QERR,
			CULTURE_SKRELL_MALISH,
			CULTURE_SKRELL_KANIN,
			CULTURE_SKRELL_TALUM,
			CULTURE_SKRELL_RASKINTA,
			CULTURE_UNATHI,
			CULTURE_SYMBIOTIC
		)
	)

/datum/species/customhuman/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN