
/datum/job/UNSC_ship/ops_chief
	title = "Operations Supervisor"
	min_rank = RANK_CWO
	default_rank = RANK_CWO
	max_rank = RANK_CWO
	flag = OPSCO
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	selection_color = "#33ccff"
	idtype = /obj/item/weapon/card/id/silver

	job_guide = "Your responsibility is to supervise general ship and bridge operations including navigation and helm control. Unfortuantely you don't have much content, but more is coming soon."

	access = list(access_unsc_bridge, access_unsc_crew, access_unsc_ops)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1

//specialist technicians for the bridge
/datum/job/UNSC_ship/ops
	title = "Operations Specialist"
	min_rank = RANK_RECRUIT
	default_rank = RANK_CREWMAN
	max_rank = RANK_PETTYM
	flag = OPS
	department_flag = ENGSEC
	total_positions = -1
	spawn_positions = 2
	selection_color = "#33ccff"
	alt_titles = list("Sensor Operator", "Electronic Warfare Specialist","Cryptologic Specialist","Signals Analyst","Navigator","Helmsman")
	job_guide = "Your job is general ship and bridge operations like navigation and helm control. Unfortunately you don't have much content but more is coming soon."

	access = list(access_unsc_bridge, access_unsc_crew, access_unsc_ops)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1

/obj/structure/closet/unsc_wardrobe/ops
	name = "operations uniforms closet"
	desc = "It's a storage unit for operations crewmen uniforms."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/unsc_wardrobe/ops/New()
	..()
	new /obj/item/clothing/under/unsc/operations(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/unsc(src)
	new /obj/item/clothing/under/unsc/operations(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/unsc(src)

/*
//coordinates fighter and shuttle traffic around the ship, including docking and departing
/datum/job/UNSC_ship/ops_traffic
	title = "Strike Traffic Controller"
	min_rank = RANK_ENSIGN
	default_rank = RANK_LT
	max_rank = RANK_CDR
	total_positions = 1
	spawn_positions = 1
	selection_color = "#33ccff"

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1

//coordinates fighter vs fighter battles
/datum/job/UNSC_ship/ops_intercept
	title = "Strike Intercept Controller"
	min_rank = RANK_ENSIGN
	default_rank = RANK_LT
	max_rank = RANK_CDR
	total_positions = 1
	spawn_positions = 1
	selection_color = "#33ccff"

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1

//coordinates marines deploying to and from the ship, including setting targets
/datum/job/UNSC_ship/ops_deploy
	title = "Marine Deployment Controller"
	min_rank = RANK_ENSIGN
	default_rank = RANK_LT
	max_rank = RANK_CDR
	total_positions = 1
	spawn_positions = 1
	selection_color = "#33ccff"

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1

//coordinates fighters attacking capital ships
/datum/job/UNSC_ship/ops_strike
	title = "Forward Strike Controller"
	min_rank = RANK_ENSIGN
	default_rank = RANK_LT
	max_rank = RANK_CDR
	total_positions = 1
	spawn_positions = 1
	selection_color = "#33ccff"

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1

//coordinates ship weapons fire
/datum/job/UNSC_ship/ops_firecontrol
	title = "Fire Control Officer"
	min_rank = RANK_LT
	default_rank = RANK_CDR
	max_rank = RANK_CDR
	total_positions = 1
	spawn_positions = 1
	selection_color = "#33ccff"

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/operations(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		return 1
*/