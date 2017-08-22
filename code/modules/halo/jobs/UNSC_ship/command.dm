
//ship commanding officer
/datum/job/UNSC_ship/commander
	title = "Commanding Officer"
	min_rank = RANK_LCDR
	default_rank = RANK_CPT
	max_rank = RANK_CPT
	flag = CO
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	selection_color = "#777777"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	job_guide = "Commander on deck! This is your ship, and your word is law. Subject matter experts have theoretical authority in their area of expertise, but otherwise everyone on the ship is a tool to complete the mission and the more that go home the better."

	access = list(access_unsc_bridge, access_unsc_tech, access_unsc_crew, access_unsc_navsec,
		access_unsc_ops, access_unsc_fighters, access_unsc_shuttles, access_unsc_medical,
		access_unsc_armoury, access_unsc_supplies, access_unsc_officers, access_unsc_marine,
		access_unsc_gunnery, access_unsc_ids)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/commander(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/command(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)

//ship 2ic officer
/datum/job/UNSC_ship/exo
	title = "Executive Officer"
	min_rank = RANK_LT
	default_rank = RANK_CDR
	max_rank = RANK_CDR
	flag = XO
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	selection_color = "#777777"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	job_guide = "You are the 2IC to the commanding officer of the ship. You are to assist him wherever possible, primarily by getting him to delegate tasks to you and other crewmembers."

	access = list(access_unsc_bridge, access_unsc_tech, access_unsc_crew, access_unsc_navsec,
		access_unsc_ops, access_unsc_fighters, access_unsc_shuttles, access_unsc_medical,
		access_unsc_armoury, access_unsc_supplies, access_unsc_officers, access_unsc_marine,
		access_unsc_gunnery, access_unsc_ids)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/commander(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/command(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)

//overall commander of strike craft
/datum/job/UNSC_ship/cag
	title = "Commander Air Group"
	min_rank = RANK_LT
	default_rank = RANK_CDR
	max_rank = RANK_CDR
	flag = CAG
	department_flag = ENGSEC
	total_positions = 1
	spawn_positions = 1
	selection_color = "#777777"
	idtype = /obj/item/weapon/card/id/silver
	job_guide = "You are the ultimate commander of all strike craft (fighters, shuttles, dropships) on the ship. You have the final word on docking approaches, fire missions, strike deployments and whether to engage or retreat. Remember to trust the word of your pilots though as you're stuck on the bridge and it's probably been decades since you flew yourself."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_ops, access_unsc_fighters, access_unsc_shuttles,
		access_unsc_armoury, access_unsc_officers)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/commander(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/command(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		return 1

//misc officers
/datum/job/UNSC_ship/bridge
	title = "Bridge Officer"
	min_rank = RANK_ENSIGN
	default_rank = RANK_LT
	max_rank = RANK_CDR
	flag = BO
	department_flag = ENGSEC
	total_positions = -1
	spawn_positions = 2
	selection_color = "#777777"
	idtype = /obj/item/weapon/card/id/silver
	job_guide = "You are a bridge officer. It's your job to push buttons, supervise and generally look busy. Try and help out one of the senior officers if you can, otherwise go and bug busy crewmen elsewhere on the ship."

	access = list(access_unsc_bridge, access_unsc_crew,
		access_unsc_ops, access_unsc_armoury, access_unsc_officers)

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/unsc/commander(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/command(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		return 1

/obj/structure/closet/unsc_wardrobe/command
	name = "command crew closet"
	desc = "It's a storage unit for command uniforms."
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/unsc_wardrobe/command/New()
	..()
	new /obj/item/clothing/under/unsc/command(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/unsc/commander(src)
	new /obj/item/clothing/under/unsc/command(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/unsc/commander(src)
