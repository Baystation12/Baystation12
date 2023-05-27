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

	rank_types = list(
		/datum/mil_rank/iccgn/or1,
		/datum/mil_rank/iccgn/or3,
		/datum/mil_rank/iccgn/or4,
		/datum/mil_rank/iccgn/or5,
		/datum/mil_rank/iccgn/or6,
		/datum/mil_rank/iccgn/or7,
		/datum/mil_rank/iccgn/or8,
		/datum/mil_rank/iccgn/or9,
		/datum/mil_rank/iccgn/or9_alt,
		/datum/mil_rank/iccgn/of1,
		/datum/mil_rank/iccgn/of2,
		/datum/mil_rank/iccgn/of3,
		/datum/mil_rank/iccgn/of4,
		/datum/mil_rank/iccgn/of5,
		/datum/mil_rank/iccgn/of6,
		/datum/mil_rank/iccgn/of7,
		/datum/mil_rank/iccgn/of8,
		/datum/mil_rank/iccgn/of9,
		/datum/mil_rank/iccgn/of9_alt
	)

	spawn_rank_types = list(
		/datum/mil_rank/iccgn/or1,
		/datum/mil_rank/iccgn/or3,
		/datum/mil_rank/iccgn/or4,
		/datum/mil_rank/iccgn/or5,
		/datum/mil_rank/iccgn/or6,
		/datum/mil_rank/iccgn/or7,
		/datum/mil_rank/iccgn/or8,
		/datum/mil_rank/iccgn/or9,
		/datum/mil_rank/iccgn/or9_alt,
		/datum/mil_rank/iccgn/of1,
		/datum/mil_rank/iccgn/of2,
		/datum/mil_rank/iccgn/of3,
		/datum/mil_rank/iccgn/of4,
		/datum/mil_rank/iccgn/of5,
		/datum/mil_rank/iccgn/of6,
		/datum/mil_rank/iccgn/of7,
		/datum/mil_rank/iccgn/of8,
		/datum/mil_rank/iccgn/of9,
		/datum/mil_rank/iccgn/of9_alt
	)


/datum/mil_branch/iccgn/New()
	rank_types = subtypesof(/datum/mil_rank/iccgn)
	..()


/datum/mil_rank/iccgn/or1
	name = "Eleve Sailor"
	name_short = "Elv"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or1
	)
	sort_order = 10


/datum/mil_rank/iccgn/or3
	name = "Sailor"
	name_short = "Slr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or3
	)
	sort_order = 30


/datum/mil_rank/iccgn/or4
	name = "Bosman"
	name_short = "Bsn"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or4
	)
	sort_order = 40


/datum/mil_rank/iccgn/or5
	name = "Starszy Bosman"
	name_short = "SBsn"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or5
	)
	sort_order = 50


/datum/mil_rank/iccgn/or6
	name = "Sierzant"
	name_short = "Szt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or6
	)
	sort_order = 60


/datum/mil_rank/iccgn/or7
	name = "Starshyna"
	name_short = "Strs"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or7
	)
	sort_order = 70


/datum/mil_rank/iccgn/or8
	name = "Adjutant"
	name_short = "Adj"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or8
	)
	sort_order = 80


/datum/mil_rank/iccgn/or9
	name = "Major"
	name_short = "Mjr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or9
	)
	sort_order = 90


/datum/mil_rank/iccgn/or9_alt
	name = "Major of the Confederation Navy"
	name_short = "MjN"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or9_alt
	)
	sort_order = 100


/datum/mil_rank/iccgn/of1
	name = "Michman"
	name_short = "Mch"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of1
	)
	sort_order = 110


/datum/mil_rank/iccgn/of2
	name = "Sous-Leytenant"
	name_short = "SLyt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of2
	)
	sort_order = 120


/datum/mil_rank/iccgn/of3
	name = "Leytenant"
	name_short = "Lyt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of3
	)
	sort_order = 130


/datum/mil_rank/iccgn/of4
	name = "Sub-Komandor"
	name_short = "SKdr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of4
	)
	sort_order = 140


/datum/mil_rank/iccgn/of5
	name = "Komandor"
	name_short = "Kdr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of5
	)
	sort_order = 150


/datum/mil_rank/iccgn/of6
	name = "Kapitan"
	name_short = "Kpt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of6
	)
	sort_order = 160


/datum/mil_rank/iccgn/of7
	name = "Starshy Kapitan"
	name_short = "SKpt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of7
	)
	sort_order = 170


/datum/mil_rank/iccgn/of8
	name = "Vice-Admiral"
	name_short = "VAdm"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of8
	)
	sort_order = 180


/datum/mil_rank/iccgn/of9
	name = "Admiral"
	name_short = "Adm"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of9
	)
	sort_order = 190


/datum/mil_rank/iccgn/of9_alt
	name = "Marshal of the Confederation Navy"
	name_short = "Mshl"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of9_alt
	)
	sort_order = 200
