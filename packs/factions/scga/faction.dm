/datum/mil_branch/scga
	name = "Sol Central Government Army"
	name_short = "SCGA"
	email_domain = "army.mil.scg"
	assistant_job = null
	min_skill = list(
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_COMBAT = SKILL_BASIC
	)

	rank_types = list(
		/datum/mil_rank/scga/e1,
		/datum/mil_rank/scga/e3,
		/datum/mil_rank/scga/e4,
		/datum/mil_rank/scga/e5,
		/datum/mil_rank/scga/e6,
		/datum/mil_rank/scga/e7,
		/datum/mil_rank/scga/e8,
		/datum/mil_rank/scga/e8_alt,
		/datum/mil_rank/scga/e9,
		/datum/mil_rank/scga/e9_alt1,
		/datum/mil_rank/scga/e9_alt2,
		/datum/mil_rank/scga/o1,
		/datum/mil_rank/scga/o2,
		/datum/mil_rank/scga/o3,
		/datum/mil_rank/scga/o4,
		/datum/mil_rank/scga/o5,
		/datum/mil_rank/scga/o6,
		/datum/mil_rank/scga/o7,
		/datum/mil_rank/scga/o8,
		/datum/mil_rank/scga/o9,
		/datum/mil_rank/scga/o10,
		/datum/mil_rank/scga/o10_alt
	)

	spawn_rank_types = list(
		/datum/mil_rank/scga/e1,
		/datum/mil_rank/scga/e3,
		/datum/mil_rank/scga/e4,
		/datum/mil_rank/scga/e5,
		/datum/mil_rank/scga/e6,
		/datum/mil_rank/scga/e7,
		/datum/mil_rank/scga/e8,
		/datum/mil_rank/scga/e8_alt,
		/datum/mil_rank/scga/e9,
		/datum/mil_rank/scga/e9_alt1,
		/datum/mil_rank/scga/e9_alt2,
		/datum/mil_rank/scga/o1,
		/datum/mil_rank/scga/o2,
		/datum/mil_rank/scga/o3,
		/datum/mil_rank/scga/o4,
		/datum/mil_rank/scga/o5,
		/datum/mil_rank/scga/o6,
		/datum/mil_rank/scga/o7,
		/datum/mil_rank/scga/o8,
		/datum/mil_rank/scga/o9,
		/datum/mil_rank/scga/o10,
		/datum/mil_rank/scga/o10_alt
	)


/datum/mil_branch/scga/New()
	rank_types = subtypesof(/datum/mil_rank/scga)
	..()


/datum/mil_rank/scga/e1
	name = "Private"
	name_short = "Pvt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e1
	)
	sort_order = 10


/datum/mil_rank/scga/e2
	name = "Private Second Class"
	name_short = "Pv2"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e2
	)
	sort_order = 20


/datum/mil_rank/scga/e3
	name = "Private First Class"
	name_short = "PFC"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e3
	)
	sort_order = 30


/datum/mil_rank/scga/e4
	name = "Corporal"
	name_short = "Cpl"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e4
	)
	sort_order = 40


/datum/mil_rank/scga/e5
	name = "Sergeant"
	name_short = "Sgt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e5
	)
	sort_order = 50


/datum/mil_rank/scga/e6
	name = "Staff Sergeant"
	name_short = "SSgt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e6
	)
	sort_order = 60


/datum/mil_rank/scga/e7
	name = "Sergeant First Class"
	name_short = "SFC"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e7
	)
	sort_order = 70


/datum/mil_rank/scga/e8
	name = "Master Sergeant"
	name_short = "MSgt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e8
	)
	sort_order = 80


/datum/mil_rank/scga/e8_alt
	name = "First Sergeant"
	name_short = "1Sgt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e8_alt
	)
	sort_order = 90


/datum/mil_rank/scga/e9
	name = "Sergeant Major"
	name_short = "SgtM"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e9
	)
	sort_order = 100


/datum/mil_rank/scga/e9_alt1
	name = "Command Sergeant Major"
	name_short = "CSM"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e9_alt1
	)
	sort_order = 110


/datum/mil_rank/scga/e9_alt2
	name = "Sergeant Major of the Army"
	name_short = "SMA"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/e9_alt2
	)
	sort_order = 120


/datum/mil_rank/scga/o1
	name = "Second Lieutenant"
	name_short = "2Lt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o1
	)
	sort_order = 130


/datum/mil_rank/scga/o2
	name = "First Lieutenant"
	name_short = "1Lt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o2
	)
	sort_order = 140


/datum/mil_rank/scga/o3
	name = "Captain"
	name_short = "Cpt"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o3
	)
	sort_order = 150


/datum/mil_rank/scga/o4
	name = "Major"
	name_short = "Mjr"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o4
	)
	sort_order = 160


/datum/mil_rank/scga/o5
	name = "Lieutenant Colonel"
	name_short = "LtC"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o5
	)
	sort_order = 170


/datum/mil_rank/scga/o6
	name = "Colonel"
	name_short = "Col"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o6
	)
	sort_order = 180


/datum/mil_rank/scga/o7
	name = "Brigadier General"
	name_short = "BrgG"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o7
	)
	sort_order = 190


/datum/mil_rank/scga/o8
	name = "Major General"
	name_short = "MjrG"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o8
	)
	sort_order = 200


/datum/mil_rank/scga/o9
	name = "Lieutenant General"
	name_short = "LtG"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o9
	)
	sort_order = 210


/datum/mil_rank/scga/o10
	name = "General"
	name_short = "Gen"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o10
	)
	sort_order = 220


/datum/mil_rank/scga/o10_alt
	name = "Field-Marshal"
	name_short = "FldM"
	accessory = list(
		/obj/item/clothing/accessory/scga_rank/o10_alt
	)
	sort_order = 230
