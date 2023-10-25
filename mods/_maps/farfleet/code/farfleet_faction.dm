/datum/mil_branch/css
	name = "Confederate Security Service"
	name_short = "ICCGCSS"
	email_domain = "css.gcc"
	assistant_job = null
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_EVA = SKILL_BASIC
	)

	rank_types = list(
		/datum/mil_rank/css/fa7,
		/datum/mil_rank/css/ia6
	)

	spawn_rank_types = list(
		/datum/mil_rank/css/fa7,
		/datum/mil_rank/css/ia6
	)


/datum/mil_branch/css/New()
	rank_types = subtypesof(/datum/mil_rank/css)
	..()


/datum/mil_rank/css/fa7
	name = "Ensign of Confederate Security"
	name_short = "EnCS"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or7
	)
	sort_order = 70


/datum/mil_rank/css/ia6
	name = "Commissar of Confederate Security"
	name_short = "ComCS"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of5
	)
	sort_order = 150
