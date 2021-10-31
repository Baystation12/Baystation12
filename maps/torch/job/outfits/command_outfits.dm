/decl/hierarchy/outfit/job/torch/crew/command
	name = OUTFIT_JOB_NAME("Torch Command Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/command
	l_ear = /obj/item/device/radio/headset/headset_com

/decl/hierarchy/outfit/job/torch/crew/command/CO
	name = OUTFIT_JOB_NAME("Commanding Officer")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	l_ear = /obj/item/device/radio/headset/heads/torchexec
	shoes = /obj/item/clothing/shoes/dutyboots
	head = /obj/item/clothing/head/soft/solgov/expedition/co
	id_types = list(/obj/item/card/id/torch/gold)
	pda_type = /obj/item/modular_computer/pda/captain

/decl/hierarchy/outfit/job/torch/crew/command/CO/New()
	..()
	BACKPACK_OVERRIDE_COMMAND

/decl/hierarchy/outfit/job/torch/crew/command/XO
	name = OUTFIT_JOB_NAME("Executive Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	l_ear = /obj/item/device/radio/headset/heads/torchexec
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/silver)
	pda_type = /obj/item/modular_computer/pda/heads/hop

/decl/hierarchy/outfit/job/torch/crew/command/XO/New()
	..()
	BACKPACK_OVERRIDE_COMMAND

/decl/hierarchy/outfit/job/torch/crew/command/XO/fleet
	name = OUTFIT_JOB_NAME("Executive Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Torch")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/silver/medical)
	pda_type = /obj/item/modular_computer/pda/heads/cmo
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew/command/cmo/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/torch/crew/command/cmo/fleet
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cmo/army
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer
	name = OUTFIT_JOB_NAME("Chief Engineer - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/engineering
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/heads/ce
	id_types = list(/obj/item/card/id/torch/silver/engineering)
	pda_type = /obj/item/modular_computer/pda/heads/ce
	pda_slot = slot_l_store
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/fleet
	name = OUTFIT_JOB_NAME("Chief Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/army
	name = OUTFIT_JOB_NAME("Chief Engineer - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cos
	name = OUTFIT_JOB_NAME("Chief of Security")
	l_ear = /obj/item/device/radio/headset/heads/cos
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/silver/security)
	pda_type = /obj/item/modular_computer/pda/heads/hos

/decl/hierarchy/outfit/job/torch/crew/command/cos/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/torch/crew/command/cos/fleet
	name = OUTFIT_JOB_NAME("Chief of Security - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cos/army
	name = OUTFIT_JOB_NAME("Chief of Security - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/passenger/workplace_liaison
	name = OUTFIT_JOB_NAME("Workplace Liaison")
	l_ear = /obj/item/device/radio/headset/heads/torchntcommand
	uniform = /obj/item/clothing/under/suit_jacket/corp
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/torch/passenger/corporate/liaison)
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher
	backpack_contents = list(/obj/item/clothing/accessory/badge/nanotrasen = 1)

/decl/hierarchy/outfit/job/torch/crew/representative
	name = OUTFIT_JOB_NAME("SolGov Representative")
	l_ear = /obj/item/device/radio/headset/headset_com
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/solgov
	suit = /obj/item/clothing/suit/storage/toggle/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/torch/crew/representative)
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher

/decl/hierarchy/outfit/job/torch/crew/command/sea/fleet
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/sea
	id_types = list(/obj/item/card/id/torch/crew/sea)
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/torch/crew/command/sea/army
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/command
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/sea
	id_types = list(/obj/item/card/id/torch/crew/sea)
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer
	name = OUTFIT_JOB_NAME("Bridge Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	shoes = /obj/item/clothing/shoes/dutyboots
	id_types = list(/obj/item/card/id/torch/crew/bridgeofficer)
	pda_type = /obj/item/modular_computer/pda/heads
	l_ear = /obj/item/device/radio/headset/bridgeofficer

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/fleet
	name = OUTFIT_JOB_NAME("Bridge Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/army
	name = OUTFIT_JOB_NAME("Bridge Officer - Army")
	uniform = /obj/item/clothing/under/solgov/utility/army/command
	shoes = /obj/item/clothing/shoes/dutyboots
