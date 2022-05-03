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


/datum/mil_rank/iccgn/e1
	name = "Sailor Recruit"
	name_short = "SlrRct"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e1
	)
	sort_order = 10


/datum/mil_rank/iccgn/e3
	name = "Sailor"
	name_short = "Slr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e3
	)
	sort_order = 30


/datum/mil_rank/iccgn/e4
	name = "Bosman"
	name_short = "Bsn"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e4
	)
	sort_order = 40


/datum/mil_rank/iccgn/e5
	name = "Starszy Bosman"
	name_short = "SBsn"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e5
	)
	sort_order = 50


/datum/mil_rank/iccgn/e6
	name = "Serzhant"
	name_short = "Szt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e6
	)
	sort_order = 60


/datum/mil_rank/iccgn/e7
	name = "Glavny Serzhant"
	name_short = "GSzt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e7
	)
	sort_order = 70


/datum/mil_rank/iccgn/e8
	name = "Starshina"
	name_short = "Str"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e8
	)
	sort_order = 80


/datum/mil_rank/iccgn/e9
	name = "Michman"
	name_short = "Mch"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/e9
	)
	sort_order = 90


/datum/mil_rank/iccgn/o1
	name = "Junker"
	name_short = "Jkr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o1
	)
	sort_order = 110


/datum/mil_rank/iccgn/o2
	name = "Leytenant"
	name_short = "Lyt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o2
	)
	sort_order = 120


/datum/mil_rank/iccgn/o3
	name = "Starshy Leytenant"
	name_short = "SLyt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o3
	)
	sort_order = 130


/datum/mil_rank/iccgn/o4
	name = "Sub-Komandor"
	name_short = "SKdr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o4
	)
	sort_order = 140


/datum/mil_rank/iccgn/o5
	name = "Komandor"
	name_short = "Kdr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o5
	)
	sort_order = 150


/datum/mil_rank/iccgn/o6
	name = "Kapitan"
	name_short = "Kpt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o6
	)
	sort_order = 160


/datum/mil_rank/iccgn/o7
	name = "Starshy Kapitan"
	name_short = "SKpt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o7
	)
	sort_order = 170


/datum/mil_rank/iccgn/o8
	name = "Vice-Admiral"
	name_short = "VAdm"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o8
	)
	sort_order = 180


/datum/mil_rank/iccgn/o9
	name = "Admiral"
	name_short = "Adm"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/o9
	)
	sort_order = 190
