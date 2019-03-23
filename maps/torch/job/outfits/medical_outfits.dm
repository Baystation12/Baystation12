/decl/hierarchy/outfit/job/torch/crew/medical
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew/medical/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/torch/crew/medical/senior
	name = OUTFIT_JOB_NAME("Physician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/medical/senior

/decl/hierarchy/outfit/job/torch/crew/medical/senior/fleet
	name = OUTFIT_JOB_NAME("Physician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/senior
	name = OUTFIT_JOB_NAME("Physician - Contractor")
	id_type = /obj/item/weapon/card/id/torch/contractor/medical/senior

/decl/hierarchy/outfit/job/torch/crew/medical/doctor
	name = OUTFIT_JOB_NAME("Medical Technician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_corpsman

/decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet
	name = OUTFIT_JOB_NAME("Medical Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/headset_corpsman

/decl/hierarchy/outfit/job/torch/crew/medical/contractor
	name = OUTFIT_JOB_NAME("Medical Technician - Contractor")
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/torch/contractor/medical

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/mortus
	name = OUTFIT_JOB_NAME("Mortician")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black

/decl/hierarchy/outfit/job/torch/crew/medical/biomech
	name = OUTFIT_JOB_NAME("Biomechanical Engineer")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/torchroboticist
	id_type = /obj/item/weapon/card/id/torch/contractor/biomech
	pda_type = /obj/item/modular_computer/pda/roboticist

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/paramedic
	name = OUTFIT_JOB_NAME("Paramedic - Torch")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	belt = /obj/item/weapon/storage/belt/medical/emt
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist
	name = OUTFIT_JOB_NAME("Chemist - Torch")
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/chemistry
	id_type = /obj/item/weapon/card/id/torch/contractor/chemist

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist/New()
	..()
	BACKPACK_OVERRIDE_CHEMISTRY

/decl/hierarchy/outfit/job/torch/crew/medical/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist - Torch")
	uniform = /obj/item/clothing/under/rank/psych
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/torch/crew/medical/psychiatrist

/decl/hierarchy/outfit/job/torch/crew/medical/psychiatrist/psychologist
	name = OUTFIT_JOB_NAME("Psychologist - Torch")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck

/decl/hierarchy/outfit/job/torch/crew/medical/psychiatrist/ec
	name = OUTFIT_JOB_NAME("Psychiatrist - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/medical/psychiatrist/fleet
	name = OUTFIT_JOB_NAME("Psychiatrist - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots