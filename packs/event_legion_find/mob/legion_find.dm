/obj/spawner/preset_human/legion_find
	mob_name = "Shepherd FIND"
	mob_pronouns = PRONOUNS_IT_ITS
	head_hair_style = "Antennae"
	species = SPECIES_IPC

	languages = list(
		LANGUAGE_HUMAN_EURO,
		LANGUAGE_HUMAN_CHINESE,
		LANGUAGE_HUMAN_ARABIC,
		LANGUAGE_HUMAN_INDIAN,
		LANGUAGE_HUMAN_IBERIAN,
		LANGUAGE_HUMAN_RUSSIAN,
		LANGUAGE_HUMAN_SELENIAN,
		LANGUAGE_GUTTER,
		LANGUAGE_SPACER,
		LANGUAGE_EAL,
		LANGUAGE_LEGION_GLOBAL
	)

	outfit = /singleton/hierarchy/outfit/legion_shepherd


/singleton/hierarchy/outfit/legion_shepherd
	name = "Legion - Shepherd"

	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/research
	shoes = /obj/item/clothing/shoes/black
	belt = /obj/item/device/personal_shield/legion
