//Cargo. Note that this is in a separate file to prevent it loading in the preferences screen in the middle of the civilian jobs. Jobs are loaded in the preferences in order by file from beginning to end.
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8c7846"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station, access_heads, access_RC_announce, access_keycard_auth, access_sec_doors)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station, access_heads, access_RC_announce, access_keycard_auth, access_sec_doors)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/qm(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargo(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/quartermaster(H), slot_belt)
//		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
		H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1



/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster"
	selection_color = "#aa9682"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cargotech(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/cargo(H), slot_belt)
//		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		return 1



/datum/job/miningforeman
	title = "Mining Foreman"
	flag = MININGFOREMAN
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the quartermaster"
	selection_color = "#aa9682"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mint, access_mining_station, access_mailsorting)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo (H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner/foreman(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/shaftminer(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
//		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_in_backpack)
		return 1

/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the mining foreman and the quartermaster"
	selection_color = "#aa9682"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mint, access_mining_station, access_mailsorting)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo (H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_eng(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/miner(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/shaftminer(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
//		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/crowbar(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/bag/ore(H), slot_in_backpack)
		return 1