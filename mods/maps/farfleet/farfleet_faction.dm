/datum/mil_branch/pioneer
	name = "Gilgamesh Confederation Pioneer Corps"
	name_short = "ICCGPC"
	email_domain = "pc.gcc"
	assistant_job = null
	min_skill = list(
		SKILL_HAULING = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_EVA = SKILL_BASIC
	)

	rank_types = list(
		/datum/mil_rank/pioneer/or3,
		/datum/mil_rank/pioneer/or5,
		/datum/mil_rank/pioneer/or7,
		/datum/mil_rank/pioneer/of1,
		/datum/mil_rank/pioneer/of3,
		/datum/mil_rank/pioneer/of5,
		/datum/mil_rank/pioneer/of6,
		/datum/mil_rank/pioneer/of8,
		/datum/mil_rank/pioneer/of9
	)

	spawn_rank_types = list(
		/datum/mil_rank/pioneer/or3,
		/datum/mil_rank/pioneer/or5,
		/datum/mil_rank/pioneer/or7,
		/datum/mil_rank/pioneer/of1,
		/datum/mil_rank/pioneer/of3,
		/datum/mil_rank/pioneer/of5,
		/datum/mil_rank/pioneer/of6,
		/datum/mil_rank/pioneer/of8,
		/datum/mil_rank/pioneer/of9
	)


/datum/mil_branch/pioneer/New()
	rank_types = subtypesof(/datum/mil_rank/pioneer)
	..()


/datum/mil_rank/pioneer/or3
	name = "Pioneer"
	name_short = "Pnr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or3
	)
	sort_order = 30


/datum/mil_rank/pioneer/or5
	name = "Pioneer-Sergeant"
	name_short = "PSnt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or5
	)
	sort_order = 50


/datum/mil_rank/pioneer/or7
	name = "Chief-Pioneer"
	name_short = "ChPr"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/or7
	)
	sort_order = 70


/datum/mil_rank/pioneer/of1
	name = "Junior Lieutenant-Pioneer"
	name_short = "JLtP"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of1
	)
	sort_order = 110


/datum/mil_rank/pioneer/of3
	name = "Lieutenant-Pioneer"
	name_short = "LtP"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of3
	)
	sort_order = 130


/datum/mil_rank/pioneer/of5
	name = "Captain-Leutenant"
	name_short = "CptLt"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of5
	)
	sort_order = 150


/datum/mil_rank/pioneer/of6
	name = "Captain of the third rank"
	name_short = "Cpt3"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of6
	)
	sort_order = 160


/datum/mil_rank/pioneer/of8
	name = "Vice-Admiral"
	name_short = "VAdm"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of8
	)
	sort_order = 180


/datum/mil_rank/pioneer/of9
	name = "Admiral of Pioneer Corps"
	name_short = "AdmPC"
	accessory = list(
		/obj/item/clothing/accessory/iccgn_rank/of9
	)
	sort_order = 190


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
