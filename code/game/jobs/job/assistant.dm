/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Security Cadet", "Lawyer","Mecha Operator","Private Eye","Reporter","Security Cadet","Test Subject","Waiter","Vice Officer")

/datum/job/assistant/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	if (H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Technical Assistant")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/color/yellow(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/yellow(H), slot_shoes)
			if("Medical Intern")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lightblue(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(H), slot_shoes)
			if("Research Assistant")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist_new(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
			if("Lawyer")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/bluesuit(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/lawyer/bluejacket(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/device/pda/lawyer2(H), slot_belt)
				H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_l_hand)
			if("Mecha Operator")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/mecha_operator(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
			if("Private Eye")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/leathercoat(H), slot_wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
				H.equip_to_slot_or_del(new /obj/item/weapon/lighter/zippo(H), slot_l_store)
			if("Reporter")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/black(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/device/pda/reporter(H), slot_belt)
			if("Security Cadet")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/cadet(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
			if("Test Subject")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/fluff/jane_sidsuit(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
			if("Waiter")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/waiter(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
			if("Vice Officer")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/vice	(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
			if("Assistant")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
