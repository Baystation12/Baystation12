/decl/hierarchy/outfit/job/medical
	hierarchy_type = /decl/hierarchy/outfit/job/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/medical
	pda_slot = slot_l_store
	backpack = /obj/item/weapon/storage/backpack/medic
	satchel_one = /obj/item/weapon/storage/backpack/satchel_med

/decl/hierarchy/outfit/job/medical/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/brown
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_pocket = /obj/item/device/flashlight/pen
	id_type = /obj/item/weapon/card/id/medical/head
	pda_type = /obj/item/device/pda/heads/cmo

/decl/hierarchy/outfit/job/medical/doctor
	name = OUTFIT_JOB_NAME("Medical Doctor")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/adv
	r_pocket = /obj/item/device/flashlight/pen
	id_type = /obj/item/weapon/card/id/medical

/decl/hierarchy/outfit/job/medical/doctor/emergency_physician
	name = OUTFIT_JOB_NAME("Emergency physician")
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket

/decl/hierarchy/outfit/job/medical/doctor/surgeon
	name = OUTFIT_JOB_NAME("Surgeon")
	uniform = /obj/item/clothing/under/rank/medical/blue
	head = /obj/item/clothing/head/surgery/blue

/decl/hierarchy/outfit/job/medical/doctor/virologist
	name = OUTFIT_JOB_NAME("Virologist")
	uniform = /obj/item/clothing/under/rank/virologist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/virologist
	mask = /obj/item/clothing/mask/surgical
	backpack = /obj/item/weapon/storage/backpack/virology
	satchel_one = /obj/item/weapon/storage/backpack/satchel_vir

/decl/hierarchy/outfit/job/medical/doctor/nurse
	name = OUTFIT_JOB_NAME("Nurse")
	suit = null

/decl/hierarchy/outfit/job/medical/doctor/nurse/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/purple
		head = null

/decl/hierarchy/outfit/job/medical/chemist
	name = OUTFIT_JOB_NAME("Chemist")
	uniform = /obj/item/clothing/under/rank/chemist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/chemist
	backpack = /obj/item/weapon/storage/backpack/chemistry
	satchel_one = /obj/item/weapon/storage/backpack/satchel_chem
	id_type = /obj/item/weapon/card/id/medical/chemist
	pda_type = /obj/item/device/pda/chemist
	backpack_contents = list(/obj/item/weapon/storage/chemical = 1)

/decl/hierarchy/outfit/job/medical/geneticist
	name = OUTFIT_JOB_NAME("Geneticist")
	uniform = /obj/item/clothing/under/rank/geneticist
	l_ear  =/obj/item/device/radio/headset/headset_medsci
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/genetics
	backpack = /obj/item/weapon/storage/backpack/genetics
	r_pocket = /obj/item/device/flashlight/pen
	satchel_one = /obj/item/weapon/storage/backpack/satchel_gen
	id_type = /obj/item/weapon/card/id/medical/geneticist
	pda_type = /obj/item/device/pda/geneticist

/decl/hierarchy/outfit/job/medical/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist")
	uniform = /obj/item/clothing/under/rank/psych
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/medical/psychiatrist

/decl/hierarchy/outfit/job/medical/psychiatrist/psychologist
	name = OUTFIT_JOB_NAME("Psychologist")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck

/decl/hierarchy/outfit/job/medical/paramedic
	name = OUTFIT_JOB_NAME("Paramedic")
	uniform = /obj/item/clothing/under/rank/medical/black
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/weapon/storage/firstaid/adv
	belt = /obj/item/weapon/storage/belt/medical/emt
	id_type = /obj/item/weapon/card/id/medical/paramedic
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/medical/paramedic/emt
	name = OUTFIT_JOB_NAME("Emergency medical technician")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
