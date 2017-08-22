
/datum/job/UNSC_ship/marine_co
	title = "Marine Commanding Officer"
	min_rank = RANK_CAPT
	default_rank = RANK_COL
	max_rank = MARINE_CO_MAX
	flag = MARCO
	department_flag = CIVILIAN
	total_positions = 1
	spawn_positions = 1
	selection_color = "#667700"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	job_guide = "Your responsibility is to command the shipboard complement of marines. Nominally you answer to the captain, but he has limited control over you once deployed. Remember that a good soldier leads from the front, but you can't lead if you're dead."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_armoury, access_unsc_officers, access_unsc_marine)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/marine(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/marine_fatigues(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/marine(H), slot_wear_suit)
		return 1

/datum/job/UNSC_ship/marine_xo
	title = "Marine Executive Officer"
	min_rank = MARINE_CO_MIN
	default_rank = RANK_1LT
	max_rank = RANK_CAPT
	flag = MARXO
	department_flag = CIVILIAN
	total_positions = 1
	spawn_positions = 1
	selection_color = "#667700"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	job_guide = "You are the 2IC of the shipboard marine complement, and what the marine CO says to you is gospel. Remember that a good soldier leads from the front, but you can't lead if you're dead."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_armoury, access_unsc_officers, access_unsc_marine)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/marine(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/marine_fatigues(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/marine(H), slot_wear_suit)
		return 1

/datum/job/UNSC_ship/marine_sl
	title = "Marine Squad Leader"
	min_rank = MARINE_SL_MIN
	default_rank = RANK_SGT
	max_rank = MARINE_SL_MAX
	flag = MARSL
	department_flag = CIVILIAN
	total_positions = 2
	spawn_positions = 6
	selection_color = "#667700"
	idtype = /obj/item/weapon/card/id/silver
	job_guide = "You lead a squad of marines (not yet implemented, so pick some guys to be in your squad and try to RP it). Your marines are the best of the best, but they're only human."

	access = list(access_unsc_crew,
		access_unsc_armoury, access_unsc_marine)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/marine(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/marine_fatigues(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/marine(H), slot_wear_suit)
		return 1

/datum/job/UNSC_ship/marine_sl/weapons
	title = "Infantry Weapons Officer"
	total_positions = 1
	spawn_positions = 4
	min_rank = RANK_GYSGT
	default_rank = RANK_GYSGT
	max_rank = RANK_MGYSGT
	flag = MARWEP
	department_flag = CIVILIAN
	job_guide = "You, master guns, know your weaponry better than almost any human alive. It's too bad you get treated like a glorified desk jockey whose main responsibility is doling out responsible portions of weaponry to needy marines."

/datum/job/UNSC_ship/marine
	title = "Marine"
	min_rank = MARINE_MIN
	default_rank = RANK_PVT
	max_rank = MARINE_MAX
	flag = MAR
	department_flag = CIVILIAN
	total_positions = -1
	spawn_positions = 12
	selection_color = "#667700"
	alt_titles = list("Machine Gunner Marine","Marine Combat Medic","Assault Recon Marine",\
	"Designated Marksman Marine","Scout Sniper Marine","Anti-Tank Missile Gunner Marine",\
	"EVA Combat Marine")
	job_guide = "Ooh rah marines! You're tha hardest son of a bitch this side of Terra and don't you know it! Other navy personnel just can't compare. Don't forget to follow orders and listen to your squad leader though."

	access = list(access_unsc_crew, access_unsc_marine)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/marine(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/marine_fatigues(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/marine(H), slot_wear_suit)
		return 1

/datum/job/UNSC_ship/marine/driver
	title = "Ground Vehicle Operator"
	flag = MARDR
	department_flag = CIVILIAN
	total_positions = 3
	spawn_positions = 5
	alt_titles = list("Light Armored Vehicle Operator","Heavy Armored Vehicle Operator","Support Vehicle Operator","Tilt-rotor/VTOL Operator")

/datum/job/UNSC_ship/marine/specialist
	title = "Combat Engineer"
	flag = MARSPEC
	department_flag = CIVILIAN
	total_positions = 3
	spawn_positions = 8
	alt_titles = list("Field Radio Operator","Explosive Ordnance Disposal Marine","Hazardous Materials Marine")

/obj/structure/closet/unsc_wardrobe/marine
	name = "marine fatigues closet"
	desc = "It's a storage unit for marine fatigues."
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/unsc_wardrobe/marine/New()
	..()
	new /obj/item/clothing/under/unsc/marine_fatigues(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/device/radio/headset/unsc/marine(src)
	new /obj/item/clothing/under/unsc/marine_fatigues(src)
	new /obj/item/clothing/shoes/marine(src)
	new /obj/item/device/radio/headset/unsc/marine(src)
	new /obj/item/clothing/head/helmet/marine(src)
	new /obj/item/clothing/suit/armor/marine(src)
