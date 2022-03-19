/datum/mil_branch/iccgn
	name = "Gilgamesh Confederation Navy"
	name_short = "ICCGN"
	email_domain = "navy.gcc"
	assistant_job = null
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_EVA = SKILL_BASIC
	)


/datum/mil_branch/iccgn/New()
	rank_types = subtypesof(/datum/mil_rank/iccgn)
	..()

	spawn_rank_types = subtypesof(/datum/mil_rank/iccgn)
	..()


/datum/mil_rank/iccgn/e1
	name = "Guardian Recruit"
	name_short = "GRDR"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e1)
	sort_order = 10

/datum/mil_rank/iccgn/e3
	name = "Guardian"
	name_short = "GRD"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e3)
	sort_order = 20

/datum/mil_rank/iccgn/e4
	name = "Corporal"
	name_short = "CPL"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e4)
	sort_order = 30

/datum/mil_rank/iccgn/e5
	name = "Star Corporal"
	name_short = "SCPL"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e5)
	sort_order = 40
/datum/mil_rank/iccgn/e6
	name = "Sergeant"
	name_short = "SGT"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e6)
	sort_order = 50

/datum/mil_rank/iccgn/e7
	name = "Laserey Sergeant"
	name_short = "LsSGT"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e7)
	sort_order = 60

/datum/mil_rank/iccgn/e8
	name = "Master Sergeant"
	name_short = "MSG"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e8)
	sort_order = 70

/datum/mil_rank/iccgn/e9
	name = "Command Master Sergeant"
	name_short = "CMS"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/e9)
	sort_order = 80

/datum/mil_rank/iccgn/o1
	name = "Junker"
	name_short = "JU"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o1)
	sort_order = 110

/datum/mil_rank/iccgn/o2
	name = "Leftenant"
	name_short = "LT"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o2)
	sort_order = 120

/datum/mil_rank/iccgn/o3
	name = "Star Leftenant"
	name_short = "SLT"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o3)
	sort_order = 130

/datum/mil_rank/iccgn/o4
	name = "Commander"
	name_short = "CDR"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o4)
	sort_order = 140

/datum/mil_rank/iccgn/o5
	name = "Star Commander"
	name_short = "SCDR"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o5)
	sort_order = 150

/datum/mil_rank/iccgn/o6
	name = "Captain"
	name_short = "CPT"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o6)
	sort_order = 160

/datum/mil_rank/iccgn/o7
	name = "Star Captain"
	name_short = "SCPT"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o7)
	sort_order = 170

/datum/mil_rank/iccgn/o8
	name = "Vice-Admiral"
	name_short = "VADM"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o8)
	sort_order = 180

/datum/mil_rank/iccgn/o9
	name = "Admiral"
	name_short = "ADM"
	accessory = list(/obj/item/clothing/accessory/iccgn_rank/o9)
	sort_order = 190