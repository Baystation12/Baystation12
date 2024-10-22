/datum/mil_branch/auf
	name = "Alliance United Flotillas"
	name_short = "AUF"
	email_domain = "flot.freeiolaus.int"
	assistant_job = null
	min_skill = list( // 5 points
		SKILL_HAULING = SKILL_BASIC, // 1 point
		SKILL_WEAPONS = SKILL_BASIC, // 2 points
		SKILL_EVA = SKILL_TRAINED // 2 point
	)

	rank_types = list(
		/datum/mil_rank/auf/ga,
		/datum/mil_rank/auf/wa,
		/datum/mil_rank/auf/sa
	)

	spawn_rank_types = list(
		/datum/mil_rank/auf/ga,
		/datum/mil_rank/auf/wa,
		/datum/mil_rank/auf/sa
	)

/datum/mil_branch/auf/New()
	rank_types = subtypesof(/datum/mil_rank/auf)
	..()

/datum/mil_rank/auf/ga
	name = "Guardsman of the Frontier Alliance"
	name_short = "GdMn"
	accessory = list(
		/obj/item/clothing/accessory/fa_badge/guardsman
	)
	sort_order = 5

/datum/mil_rank/auf/wa
	name = "Warden of the Frontier Alliance"
	name_short = "Wrd"
	accessory = list(
		/obj/item/clothing/accessory/fa_badge/warden
	)
	sort_order = 13

/datum/mil_rank/auf/sa
	name = "Star Marshal of the Frontier Alliance"
	name_short = "Mrshl"
	accessory = list(
		/obj/item/clothing/accessory/fa_badge/marshal
	)
	sort_order = 20