/decl/hierarchy/outfit/job/torch/crew/security
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/security
	l_ear = /obj/item/device/radio/headset/headset_sec
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/torch/crew/security/brig_chief
	name = OUTFIT_JOB_NAME("Brig Chief")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/security/brigchief)
	pda_type = /obj/item/modular_computer/pda/security

/decl/hierarchy/outfit/job/torch/crew/security/brig_chief/fleet
	name = OUTFIT_JOB_NAME("Brig Chief - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/brig_chief/army
	name = OUTFIT_JOB_NAME("Brig Chief - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	name = OUTFIT_JOB_NAME("Forensic Technician - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/security/forensic)
	pda_type = /obj/item/modular_computer/pda/forensics

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/contractor
	name = OUTFIT_JOB_NAME("Forensic Technician - Contractor")
	uniform = /obj/item/clothing/under/det
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/clothing/accessory/badge/PI = 1)

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/fleet
	name = OUTFIT_JOB_NAME("Forensic Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/agent
	name = OUTFIT_JOB_NAME("Forensic Technician - SFP Agent")
	uniform = /obj/item/clothing/under/det/grey
	suit = /obj/item/clothing/suit/storage/toggle/agent_jacket
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/job/torch/crew/security/maa
	name = OUTFIT_JOB_NAME("Master at Arms")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/security)
	pda_type = /obj/item/modular_computer/pda/security

/decl/hierarchy/outfit/job/torch/crew/security/maa/fleet
	name = OUTFIT_JOB_NAME("Master at Arms - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/maa/army
	name = OUTFIT_JOB_NAME("Master at Arms - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/security
	shoes = /obj/item/clothing/shoes/dutyboots
