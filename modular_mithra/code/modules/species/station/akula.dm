/datum/species/akula
	name = SPECIES_AKULA
	name_plural = SPECIES_AKULA
	icobase = 'modular_mithra/icons/mob/human_races/species/akula/body.dmi'
	deform = 'modular_mithra/icons/mob/human_races/species/akula/deformed_body.dmi'
	husk_icon = 'modular_mithra/icons/mob/human_races/species/akula/husk.dmi'
	preview_icon = 'modular_mithra/icons/mob/human_races/species/akula/preview.dmi'
	modular_tail = 'modular_mithra/icons/mob/human_races/species/akula/tail.dmi'
	tail = "aktail"
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,/datum/unarmed_attack/tail, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp)

	description = "A genemod, divergent from Tritonians by the addition of additional muscle mass and sharper teeth. Though both races are Human-based genemods that arose from the conditions of their aquatic colony-planet, Koster-4, Tritonians have generally always been a more popular choice of genemod, due to an Akula's large dietary needs."

	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_ICONBASE
	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	sexybits_location = BP_GROIN //this is possibly my favorite variable just because of how out of place it is.


	available_cultural_info = list( //I can do ANYTHING! Placeholder until the loreboys come and figure out what Akula do | did it - bear
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
			CULTURE_SYMBIOTIC,
			CULTURE_HUMAN_OTHER
		)
	)
	override_organ_types = list(BP_LUNGS = /obj/item/organ/internal/lungs/gills)
