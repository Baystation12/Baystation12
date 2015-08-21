/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO
	head_position = 1
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddf0"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks)
	minimal_player_age = 10

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/cmo(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_medical_officer(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/cmo(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return 1

/datum/job/doctor
	title = "Medical Doctor"
	flag = DOCTOR
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 7
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_virology)
	alt_titles = list("Surgeon","Emergency Physician","Nurse","Virologist")

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		if (H.mind.role_alt_title)
			switch(H.mind.role_alt_title)
				if("Emergency Physician")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/fr_jacket(H), slot_wear_suit)
				if("Surgeon")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/blue(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/blue(H), slot_head)
				if("Virologist")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/virologist(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/virologist(H), slot_wear_suit)
					H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), slot_wear_mask)
					switch(H.backbag)
						if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/virology(H), slot_back)
						if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_vir(H), slot_back)
						if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
				if("Medical Doctor")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
				if("Nurse")
					if(H.gender == FEMALE)
						if(prob(50))
							H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/nursesuit(H), slot_w_uniform)
						else
							H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/nurse(H), slot_w_uniform)
						H.equip_to_slot_or_del(new /obj/item/clothing/head/nursehat(H), slot_head)
					else
						H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/purple(H), slot_w_uniform)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return 1



//Chemist is a medical job damnit	//YEAH FUCK YOU SCIENCE	-Pete	//Guys, behave -Erro
/datum/job/chemist
	title = "Chemist"
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 5
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_medical_equip, access_chemistry)
	alt_titles = list("Pharmacist")


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chemist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/chemist(H), slot_belt)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/chemistry(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_chem(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/chemist(H), slot_wear_suit)
		return 1



/datum/job/geneticist
	title = "Geneticist"
	flag = GENETICIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "the chief medical officer and research director"
	selection_color = "#ffeef0"
	economic_modifier = 7
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_research)
	minimal_access = list(access_medical, access_morgue, access_genetics, access_research)


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_medsci(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/geneticist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/geneticist(H), slot_belt)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/genetics(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_gen(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/pen(H), slot_s_store)
		return 1

/datum/job/psychiatrist
	title = "Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_psychiatrist)
	alt_titles = list("Psychologist")

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		if (H.mind.role_alt_title)
			switch(H.mind.role_alt_title)
				if("Psychiatrist")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/psych(H), slot_w_uniform)
				if("Psychologist")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/psych/turtleneck(H), slot_w_uniform)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)


/datum/job/Paramedic
	title = "Paramedic"
	flag = PARAMEDIC
	department = "Medical"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#ffeef0"
	economic_modifier = 4
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist)
	minimal_access = list(access_medical, access_medical_equip, access_eva, access_maint_tunnels, access_external_airlocks)
	alt_titles = list("Emergency Medical Technician")

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		if (H.mind.role_alt_title)
			switch(H.mind.role_alt_title)
				if("Emergency Medical Technician")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/paramedic(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/fr_jacket(H), slot_wear_suit)
				if("Paramedic")
					H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical/black(H), slot_w_uniform)
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/fr_jacket(H), slot_wear_suit)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical/emt(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_l_store)
		return 1

	equip_survival(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.species.equip_survival_gear(H,1)
		return 1
