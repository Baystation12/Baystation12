//Job Outfits

/*
TORCH OUTFITS
Keeping them simple for now, just spawning with basic EC uniforms, and pretty much no gear. Gear instead goes in lockers. Keep this in mind if editing.
*/

/decl/hierarchy/outfit/job/torch
	name = OUTFIT_JOB_NAME("Torch Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew
	name = OUTFIT_JOB_NAME("Torch Crew Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/fleet
	name = OUTFIT_JOB_NAME("Torch Fleet Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/fleet
	uniform = /obj/item/clothing/under/solgov/utility/fleet
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/marine
	name = OUTFIT_JOB_NAME("Torch Marine Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/marine
	uniform = /obj/item/clothing/under/solgov/utility/marine
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/passenger
	name = OUTFIT_JOB_NAME("Torch Passenger")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/passenger
	uniform = /obj/item/clothing/under/solgov/utility

//Command Outfits
/decl/hierarchy/outfit/job/torch/crew/command
	name = OUTFIT_JOB_NAME("Torch Command Outfit")
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/command
	l_ear = /obj/item/device/radio/headset/headset_com

/decl/hierarchy/outfit/job/torch/crew/command/CO
	name = OUTFIT_JOB_NAME("Commanding Officer")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	l_ear = /obj/item/device/radio/headset/heads/torchcaptain
	shoes = /obj/item/clothing/shoes/dutyboots
	head = /obj/item/clothing/head/soft/solgov/expedition/co
	id_type = /obj/item/weapon/card/id/torch/gold
	pda_type = /obj/item/device/pda/captain

/decl/hierarchy/outfit/job/torch/crew/command/CO/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack] = /obj/item/weapon/storage/backpack/captain
	backpack_overrides[/decl/backpack_outfit/satchel] = /obj/item/weapon/storage/backpack/satchel_cap
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/com

/decl/hierarchy/outfit/job/torch/crew/command/XO
	name = OUTFIT_JOB_NAME("Executive Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	l_ear = /obj/item/device/radio/headset/heads/torchxo
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/silver
	pda_type = /obj/item/device/pda/heads/hop

/decl/hierarchy/outfit/job/torch/crew/command/XO/fleet
	name = OUTFIT_JOB_NAME("Executive Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/XO/marine
	name = OUTFIT_JOB_NAME("Executive Officer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/command
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/passenger/research/rd
	name = OUTFIT_JOB_NAME("Research Director - Torch")
	l_ear = /obj/item/device/radio/headset/heads/torchntcommand
	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/torch/silver/research
	pda_type = /obj/item/device/pda/heads/rd

/decl/hierarchy/outfit/job/torch/crew/command/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Torch")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/silver/medical
	pda_type = /obj/item/device/pda/heads/cmo
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew/command/cmo/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/torch/crew/command/cmo/fleet
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer
	name = OUTFIT_JOB_NAME("Chief Engineer - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/engineering
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/heads/ce
	id_type = /obj/item/weapon/card/id/torch/silver/engineering
	pda_type = /obj/item/device/pda/heads/ce
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/command/cos/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/fleet
	name = OUTFIT_JOB_NAME("Chief Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/marine
	name = OUTFIT_JOB_NAME("Chief Engineer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/engineering
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/command/cos
	name = OUTFIT_JOB_NAME("Chief of Security")
	l_ear = /obj/item/device/radio/headset/heads/cos
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/silver/security
	pda_type = /obj/item/device/pda/heads/hos

/decl/hierarchy/outfit/job/torch/crew/command/cos/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/torch/crew/command/cos/fleet
	name = OUTFIT_JOB_NAME("Chief of Security - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cos/marine
	name = OUTFIT_JOB_NAME("Chief of Security - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/security
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/passenger/research/cl
	name = OUTFIT_JOB_NAME("NanoTrasen Liaison")
	l_ear = /obj/item/device/radio/headset/heads/torchntcommand
	uniform = /obj/item/clothing/under/suit_jacket/nt
	suit = /obj/item/clothing/suit/storage/toggle/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/passenger/research/liaison
	pda_type = /obj/item/device/pda/heads

/decl/hierarchy/outfit/job/torch/crew/representative
	name = OUTFIT_JOB_NAME("SolGov Representative")
	l_ear = /obj/item/device/radio/headset/headset_com
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/solgov
	suit = /obj/item/clothing/suit/storage/toggle/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/crew/representative
	pda_type = /obj/item/device/pda/heads
	backpack_contents = list(/obj/item/clothing/accessory/badge/solgov/representative = 1)

/decl/hierarchy/outfit/job/torch/crew/command/sea
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/command
	l_ear = /obj/item/device/radio/headset/heads/torchxo
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/sea
	pda_type = /obj/item/device/pda/heads

/decl/hierarchy/outfit/job/torch/crew/command/sea/fleet
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/sea/marine
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/command
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer
	name = OUTFIT_JOB_NAME("Bridge Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/bridgeofficer
	pda_type = /obj/item/device/pda/heads
	l_ear = /obj/item/device/radio/headset/bridgeofficer

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/fleet
	name = OUTFIT_JOB_NAME("Bridge Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/marine
	name = OUTFIT_JOB_NAME("Bridge Officer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/command
	shoes = /obj/item/clothing/shoes/jungleboots

//Engineering Outfits

/decl/hierarchy/outfit/job/torch/crew/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/engineering
	l_ear = /obj/item/device/radio/headset/headset_eng
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/engineering/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer
	name = OUTFIT_JOB_NAME("Senior Engineer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/engineering
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/engineering/senior
	pda_type = /obj/item/device/pda/heads/ce

/decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/fleet
	name = OUTFIT_JOB_NAME("Senior Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/marine
	name = OUTFIT_JOB_NAME("Senior Engineer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/engineering
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/engineering
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/engineering
	pda_type = /obj/item/device/pda/engineering

/decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet
	name = OUTFIT_JOB_NAME("Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/engineering/engineer/marine
	name = OUTFIT_JOB_NAME("Engineer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/engineering
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	name = OUTFIT_JOB_NAME("Engineering Assistant")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/contractor/engineering
	pda_type = /obj/item/device/pda/engineering

/decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	name = OUTFIT_JOB_NAME("Roboticist - Torch")
	uniform = /obj/item/clothing/under/rank/roboticist
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/torch/contractor/engineering/roboticist
	pda_type = /obj/item/device/pda/roboticist

//Security Outfits

/decl/hierarchy/outfit/job/torch/crew/security
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/security
	l_ear = /obj/item/device/radio/headset/headset_sec
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/torch/crew/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/torch/crew/security/brig_officer
	name = OUTFIT_JOB_NAME("Brig Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/security/brigofficer
	pda_type = /obj/item/device/pda/warden

/decl/hierarchy/outfit/job/torch/crew/security/brig_officer/fleet
	name = OUTFIT_JOB_NAME("Brig Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/brig_officer/marine
	name = OUTFIT_JOB_NAME("Brig Officer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/security
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	name = OUTFIT_JOB_NAME("Forensic Technician - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/security/forensic
	pda_type = /obj/item/device/pda/detective

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/fleet
	name = OUTFIT_JOB_NAME("Forensic Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/marine
	name = OUTFIT_JOB_NAME("Forensic Technician - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/security
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/civ
	name = OUTFIT_JOB_NAME("Forensic Technician - Civilian")
	uniform = /obj/item/clothing/under/det/grey
	suit = /obj/item/clothing/suit/storage/toggle/marshal_jacket
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/job/torch/crew/security/maa
	name = OUTFIT_JOB_NAME("Master at Arms")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/security
	pda_type = /obj/item/device/pda/security

/decl/hierarchy/outfit/job/torch/crew/security/maa/fleet
	name = OUTFIT_JOB_NAME("Master at Arms - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/maa/marine
	name = OUTFIT_JOB_NAME("Master at Arms - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/security
	shoes = /obj/item/clothing/shoes/jungleboots

//Medical Outfits

/decl/hierarchy/outfit/job/torch/crew/medical
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	pda_type = /obj/item/device/pda/medical
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

/decl/hierarchy/outfit/job/torch/crew/medical/doctor
	name = OUTFIT_JOB_NAME("Corpsman")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/medical

/decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet
	name = OUTFIT_JOB_NAME("Corpsman - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/medical/doctor/medic
	name = OUTFIT_JOB_NAME("Corpsman - Medic")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/medical/contractor
	name = OUTFIT_JOB_NAME("Medical Contractor")
	uniform = /obj/item/clothing/under/rank/medical
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/torch/contractor/medical

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/orderly
	name = OUTFIT_JOB_NAME("Orderly")
	uniform = /obj/item/clothing/under/rank/orderly

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/resident
	name = OUTFIT_JOB_NAME("Medical Resident")
	uniform = /obj/item/clothing/under/color/white

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/xenosurgeon
	name = OUTFIT_JOB_NAME("Xenosurgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/purple

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/mortus
	name = OUTFIT_JOB_NAME("Mortician")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/virologist
	name = OUTFIT_JOB_NAME("Virologist - Torch")
	uniform = /obj/item/clothing/under/rank/virologist

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/virologist/New()
	..()
	BACKPACK_OVERRIDE_VIROLOGY

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/paramedic
	name = OUTFIT_JOB_NAME("Paramedic - Torch")
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/weapon/storage/firstaid/adv
	belt = /obj/item/weapon/storage/belt/medical/emt
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist
	name = OUTFIT_JOB_NAME("Chemist - Torch")
	uniform = /obj/item/clothing/under/rank/chemist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/chemist
	id_type = /obj/item/weapon/card/id/torch/contractor/chemist

/decl/hierarchy/outfit/job/torch/crew/medical/contractor/chemist/New()
	..()
	BACKPACK_OVERRIDE_CHEMISTRY

/decl/hierarchy/outfit/job/torch/crew/medical/counselor
	name = OUTFIT_JOB_NAME("Counselor")
	uniform = /obj/item/clothing/under/rank/psych/turtleneck
	shoes = /obj/item/clothing/shoes/white
	id_type = /obj/item/weapon/card/id/torch/contractor/medical/counselor

/decl/hierarchy/outfit/job/torch/crew/medical/counselor/psychiatrist
	name = OUTFIT_JOB_NAME("Psychiatrist - Torch")
	uniform = /obj/item/clothing/under/rank/psych

/decl/hierarchy/outfit/job/torch/crew/medical/counselor/chaplain
	name = OUTFIT_JOB_NAME("Chaplain - Torch")
	uniform = /obj/item/clothing/under/rank/chaplain

/decl/hierarchy/outfit/job/torch/crew/medical/counselor/ec
	name = OUTFIT_JOB_NAME("Counselor - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/medical/counselor/fleet
	name = OUTFIT_JOB_NAME("Counselor - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots

//Supply Outfits

/decl/hierarchy/outfit/job/torch/crew/supply
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/supply

/decl/hierarchy/outfit/job/torch/crew/supply/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer
	name = OUTFIT_JOB_NAME("Deck Officer")
	l_ear = /obj/item/device/radio/headset/headset_deckofficer
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/supply/deckofficer
	pda_type = /obj/item/device/pda/quartermaster

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/fleet
	name = OUTFIT_JOB_NAME("Deck Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/marine
	name = OUTFIT_JOB_NAME("Deck Officer - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/supply
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/supply/tech
	name = OUTFIT_JOB_NAME("Deck Technician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/supply
	pda_type = /obj/item/device/pda/cargo

/decl/hierarchy/outfit/job/torch/crew/supply/tech/fleet
	name = OUTFIT_JOB_NAME("Deck Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/supply/tech/marine
	name = OUTFIT_JOB_NAME("Deck Technician - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/supply
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/supply/contractor
	name = OUTFIT_JOB_NAME("Supply Assistant")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/torch/contractor/supply
	pda_type = /obj/item/device/pda/cargo


//Service Outfits

/decl/hierarchy/outfit/job/torch/crew/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/service

/decl/hierarchy/outfit/job/torch/crew/service/janitor
	name = OUTFIT_JOB_NAME("Sanitation Technician - Torch")
	uniform = /obj/item/clothing/under/rank/janitor
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/torch/crew/service/janitor
	pda_type = /obj/item/device/pda/janitor

/decl/hierarchy/outfit/job/torch/crew/service/janitor/ec
	name = OUTFIT_JOB_NAME("Sanitation Technician - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/service
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/service/janitor
	pda_type = /obj/item/device/pda/janitor

/decl/hierarchy/outfit/job/torch/crew/service/janitor/fleet
	name = OUTFIT_JOB_NAME("Sanitation Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/service
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/service/janitor/marine
	name = OUTFIT_JOB_NAME("Sanitation Technician - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/service
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/service/cook
	name = OUTFIT_JOB_NAME("Cook - Torch")
	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/torch/crew/service/chef
	pda_type = /obj/item/device/pda/chef

/decl/hierarchy/outfit/job/torch/crew/service/cook/ec
	name = OUTFIT_JOB_NAME("Cook - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/service
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/service/chef
	pda_type = /obj/item/device/pda/chef

/decl/hierarchy/outfit/job/torch/crew/service/cook/fleet
	name = OUTFIT_JOB_NAME("Cook - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/service
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/service/cook/marine
	name = OUTFIT_JOB_NAME("Cook - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine/service
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/crew/service/bartender
	name = OUTFIT_JOB_NAME("Bartender - Torch")
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/contractor/service/bartender
	pda_type = /obj/item/device/pda/bar

/decl/hierarchy/outfit/job/torch/crew/service/crewman
	name = OUTFIT_JOB_NAME("Crewman")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew
	pda_type = /obj/item/device/pda

/decl/hierarchy/outfit/job/torch/crew/service/crewman/fleet
	name = OUTFIT_JOB_NAME("Crewman - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/service/crewman/marine
	name = OUTFIT_JOB_NAME("Crewman - Marine")
	uniform = /obj/item/clothing/under/solgov/utility/marine
	shoes = /obj/item/clothing/shoes/jungleboots

//Exploration Outfits

/decl/hierarchy/outfit/job/torch/crew/exploration/pathfinder
	name = OUTFIT_JOB_NAME("Pathfinder")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/exploration
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/pathfinder
	pda_type = /obj/item/device/pda/pathfinder
	l_ear = /obj/item/device/radio/headset/pathfinder

/decl/hierarchy/outfit/job/torch/crew/exploration/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/exploration
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/explorer
	pda_type = /obj/item/device/pda/explorer
	l_ear = /obj/item/device/radio/headset/exploration

//Passenger Outfits

/decl/hierarchy/outfit/job/torch/passenger/research
	hierarchy_type = /decl/hierarchy/outfit/job/torch/passenger/research
	l_ear = /obj/item/device/radio/headset/torchnanotrasen

/decl/hierarchy/outfit/job/torch/passenger/research/senior_scientist
	name = OUTFIT_JOB_NAME("Senior Researcher")
	uniform = /obj/item/clothing/under/rank/scientist/executive
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/heads/rd
	id_type = /obj/item/weapon/card/id/torch/passenger/research/senior_scientist

/decl/hierarchy/outfit/job/torch/passenger/research/senior_scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot //pending better uniform
	name = OUTFIT_JOB_NAME("NanoTrasen Pilot")
	uniform = /obj/item/clothing/under/rank/ntpilot
	suit = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/passenger/research/nt_pilot

/decl/hierarchy/outfit/job/torch/passenger/research/scientist
	name = OUTFIT_JOB_NAME("Scientist - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research/scientist

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/psych
	name = OUTFIT_JOB_NAME("Psychologist - Torch")
	uniform = /obj/item/clothing/under/rank/psych

/decl/hierarchy/outfit/job/torch/passenger/research/prospector
	name = OUTFIT_JOB_NAME("Prospector")
	uniform = /obj/item/clothing/under/rank/ntwork
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/passenger/research/mining
	pda_type = /obj/item/device/pda/shaftminer
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/passenger/research/prospector/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/passenger/research/guard
	name = OUTFIT_JOB_NAME("Security Guard")
	uniform = /obj/item/clothing/under/rank/guard
	shoes = /obj/item/clothing/shoes/jackboots
	id_type = /obj/item/weapon/card/id/torch/passenger/research/guard
	pda_type = /obj/item/device/pda/security

/decl/hierarchy/outfit/job/torch/passenger/research/guard/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/torch/passenger/research/assist
	name = OUTFIT_JOB_NAME("Research Assistant - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/device/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research

/decl/hierarchy/outfit/job/torch/passenger/research/assist/janitor
	name = OUTFIT_JOB_NAME("Custodian - Torch")
	uniform = /obj/item/clothing/under/rank/janitor

/decl/hierarchy/outfit/job/torch/passenger/research/assist/testsubject
	name = OUTFIT_JOB_NAME("Testing Assistant")
	uniform = /obj/item/clothing/under/rank/ntwork

/decl/hierarchy/outfit/job/torch/passenger/passenger
	name = OUTFIT_JOB_NAME("Passenger - Torch")
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/torch/passenger

/decl/hierarchy/outfit/job/torch/passenger/passenger/PI
	name = OUTFIT_JOB_NAME("Private Investigator - Torch")
	backpack_contents = list(/obj/item/clothing/accessory/badge = 1)

/decl/hierarchy/outfit/job/torch/passenger/passenger/journalist
	name = OUTFIT_JOB_NAME("Journalist - Torch")
	backpack_contents = list(/obj/item/device/tvcamera = 1,
	/obj/item/clothing/accessory/badge/press = 1)

/decl/hierarchy/outfit/job/torch/merchant
	name = OUTFIT_JOB_NAME("Merchant - Torch")
	uniform = /obj/item/clothing/under/color/black
	l_ear = null
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/device/pda
	id_type = /obj/item/weapon/card/id/torch/merchant

/decl/hierarchy/outfit/job/torch/stowaway
	name = OUTFIT_JOB_NAME("Stowaway - Torch")
	id_type = null
	pda_type = null
	l_ear = null
	l_pocket = /obj/item/weapon/wrench
	r_pocket = /obj/item/weapon/crowbar

/decl/hierarchy/outfit/job/torch/stowaway/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/torch/stowaway/ID = new(H.loc)
	H.put_in_hands(ID)
