/datum/job/rd
	title = "Research Director"
	flag = RD
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_if_possible(new /obj/item/device/radio/headset/heads/rd(H), H.slot_ears)
		H.equip_if_possible(new /obj/item/clothing/shoes/brown(H), H.slot_shoes)
		H.equip_if_possible(new /obj/item/clothing/under/rank/research_director(H), H.slot_w_uniform)
		H.equip_if_possible(new /obj/item/device/pda/heads/rd(H), H.slot_belt)
		H.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat(H), H.slot_wear_suit)
		H.equip_if_possible(new /obj/item/weapon/clipboard(H), H.slot_l_store)
		return 1



/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	alt_titles = list("Plasma Researcher", "Xenobiologist")


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		if(H.backbag == 2) H.equip_if_possible(new /obj/item/weapon/storage/backpack(H), H.slot_back)
		if(H.backbag == 3) H.equip_if_possible(new /obj/item/weapon/storage/backpack/satchel(H), H.slot_back)
		if(H.backbag == 4) H.equip_if_possible(new /obj/item/weapon/storage/backpack/satchel_tox(H), H.slot_back)
		H.equip_if_possible(new /obj/item/device/radio/headset/headset_sci(H), H.slot_ears)
		H.equip_if_possible(new /obj/item/clothing/under/rank/scientist(H), H.slot_w_uniform)
		H.equip_if_possible(new /obj/item/clothing/shoes/white(H), H.slot_shoes)
		H.equip_if_possible(new /obj/item/device/pda/toxins(H), H.slot_belt)
		H.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat/science(H), H.slot_wear_suit)
		H.equip_if_possible(new /obj/item/clothing/mask/gas(H), H.slot_wear_mask)
		H.equip_if_possible(new /obj/item/weapon/tank/oxygen(H), H.slot_l_hand)
		return 1


//Chemist is a medical job damnit
/datum/job/chemist
	title = "Chemist"
	flag = CHEMIST
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief medical officer and the research director"
	selection_color = "#ffeeff"


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		if(H.backbag == 2) H.equip_if_possible(new /obj/item/weapon/storage/backpack(H), H.slot_back)
		if(H.backbag == 3) H.equip_if_possible(new /obj/item/weapon/storage/backpack/satchel(H), H.slot_back)
		if(H.backbag == 4) H.equip_if_possible(new /obj/item/weapon/storage/backpack/satchel_chem(H), H.slot_back)
		H.equip_if_possible(new /obj/item/device/radio/headset/headset_medsci(H), H.slot_ears)
		H.equip_if_possible(new /obj/item/clothing/under/rank/chemist(H), H.slot_w_uniform)
		H.equip_if_possible(new /obj/item/clothing/shoes/white(H), H.slot_shoes)
		H.equip_if_possible(new /obj/item/device/pda/toxins(H), H.slot_belt)
		H.equip_if_possible(new /obj/item/clothing/suit/storage/labcoat/chemist(H), H.slot_wear_suit)
		return 1
