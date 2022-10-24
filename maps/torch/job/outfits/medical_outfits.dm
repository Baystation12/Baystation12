/singleton/hierarchy/outfit/job/torch/crew/medical
	hierarchy_type = /singleton/hierarchy/outfit/job/torch/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store

/singleton/hierarchy/outfit/job/torch/crew/medical/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/singleton/hierarchy/outfit/job/torch/crew/medical/senior
	name = OUTFIT_JOB_NAME("Physician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/medical/senior)

/singleton/hierarchy/outfit/job/torch/crew/medical/senior/fleet
	name = OUTFIT_JOB_NAME("Physician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor/senior
	name = OUTFIT_JOB_NAME("Physician - Contractor")
	id_types = list(/obj/item/card/id/torch/contractor/medical/senior)

/singleton/hierarchy/outfit/job/torch/crew/medical/junior
	name = OUTFIT_JOB_NAME("Medical Resident")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/medical/senior)

/singleton/hierarchy/outfit/job/torch/crew/medical/junior/fleet
	name = OUTFIT_JOB_NAME("Medical Resident - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor/junior
	name = OUTFIT_JOB_NAME("Medical Resident - Contractor")
	id_types = list(/obj/item/card/id/torch/contractor/medical/senior)

/singleton/hierarchy/outfit/job/torch/crew/medical/doctor
	name = OUTFIT_JOB_NAME("Medical Technician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/medical)
	l_ear = /obj/item/device/radio/headset/headset_corpsman

/singleton/hierarchy/outfit/job/torch/crew/medical/doctor/fleet
	name = OUTFIT_JOB_NAME("Medical Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/headset_corpsman

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor
	name = OUTFIT_JOB_NAME("Medical Technician - Contractor")
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/white
	id_types = list(/obj/item/card/id/torch/contractor/medical)

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor/mortus
	name = OUTFIT_JOB_NAME("Mortician")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor/paramedic
	name = OUTFIT_JOB_NAME("Paramedic - Torch")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor/chemist
	name = OUTFIT_JOB_NAME("Chemist - Torch")
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/chemistry
	id_types = list(/obj/item/card/id/torch/contractor/chemist)

/singleton/hierarchy/outfit/job/torch/crew/medical/contractor/chemist/New()
	..()
	BACKPACK_OVERRIDE_CHEMISTRY

/singleton/hierarchy/outfit/job/torch/crew/medical/counselor
	name = OUTFIT_JOB_NAME("Counselor")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck
	shoes = /obj/item/clothing/shoes/white
	id_types = list(/obj/item/card/id/torch/contractor/medical/counselor)

/singleton/hierarchy/outfit/job/torch/crew/medical/counselor/ec
	name = OUTFIT_JOB_NAME("Counselor - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/medical/counselor)

/singleton/hierarchy/outfit/job/torch/crew/medical/counselor/fleet
	name = OUTFIT_JOB_NAME("Counselor - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/medical/counselor)
