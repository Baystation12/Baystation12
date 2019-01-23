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
	pda_type = /obj/item/modular_computer/pda
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
	l_ear = /obj/item/device/radio/headset/heads/torchexec
	shoes = /obj/item/clothing/shoes/dutyboots
	head = /obj/item/clothing/head/soft/solgov/expedition/co
	id_type = /obj/item/weapon/card/id/torch/gold
	pda_type = /obj/item/modular_computer/pda/captain

/decl/hierarchy/outfit/job/torch/crew/command/CO/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack] = /obj/item/weapon/storage/backpack/captain
	backpack_overrides[/decl/backpack_outfit/satchel] = /obj/item/weapon/storage/backpack/satchel/cap
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/com

/decl/hierarchy/outfit/job/torch/crew/command/XO
	name = OUTFIT_JOB_NAME("Executive Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	l_ear = /obj/item/device/radio/headset/heads/torchexec
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/silver
	pda_type = /obj/item/modular_computer/pda/heads/hop

/decl/hierarchy/outfit/job/torch/crew/command/XO/fleet
	name = OUTFIT_JOB_NAME("Executive Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Torch")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/silver/medical
	pda_type = /obj/item/modular_computer/pda/heads/cmo
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
	pda_type = /obj/item/modular_computer/pda/heads/ce
	pda_slot = slot_l_store
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/crew/command/chief_engineer/fleet
	name = OUTFIT_JOB_NAME("Chief Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/command/cos
	name = OUTFIT_JOB_NAME("Chief of Security")
	l_ear = /obj/item/device/radio/headset/heads/cos
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/silver/security
	pda_type = /obj/item/modular_computer/pda/heads/hos

/decl/hierarchy/outfit/job/torch/crew/command/cos/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/torch/crew/command/cos/fleet
	name = OUTFIT_JOB_NAME("Chief of Security - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/passenger/workplace_liaison
	name = OUTFIT_JOB_NAME("Workplace Liaison")
	l_ear = /obj/item/device/radio/headset/heads/torchntcommand
	uniform = /obj/item/clothing/under/suit_jacket/corp
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/passenger/corporate/liaison
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher
	backpack_contents = list(/obj/item/clothing/accessory/badge/nanotrasen = 1)

/decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard
	name = OUTFIT_JOB_NAME("Loss Prevention Associate")
	l_ear =    /obj/item/device/radio/headset/heads/torchcorp
	uniform =  /obj/item/clothing/under/suit_jacket/corp
	shoes =    /obj/item/clothing/shoes/laceup
	id_type =  /obj/item/weapon/card/id/torch/passenger/corporate
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher

/decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard/union
	name = OUTFIT_JOB_NAME("Union Enforcer")
	l_pocket = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	r_pocket = /obj/item/weapon/flame/lighter/zippo

/decl/hierarchy/outfit/job/torch/passenger/corporate_bodyguard/equip(mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	. = ..()
	if(H)
		var/obj/item/weapon/gun/energy/gun/secure/corporate/firearm = new(H)
		if(istype(H.w_uniform, /obj/item/clothing))
			var/obj/item/clothing/uniform = H.w_uniform
			var/obj/item/clothing/accessory/storage/holster/thigh/holster = new(H)
			if(uniform.can_attach_accessory(holster))
				var/datum/extension/holster/holster_extension = get_extension(holster, /datum/extension/holster)
				holster_extension.holstered = firearm
				firearm.forceMove(holster)
				uniform.attackby(holster, H)
			else
				qdel(holster)
		if(firearm.loc == H)
			H.put_in_any_hand_if_possible(firearm)
			if(H.l_hand != firearm && H.r_hand != firearm)
				firearm.forceMove(get_turf(H))

/decl/hierarchy/outfit/job/torch/passenger/workplace_liaison/union_rep
	name = OUTFIT_JOB_NAME("Union Representative")
	l_pocket = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	r_pocket = /obj/item/weapon/flame/lighter/zippo

/decl/hierarchy/outfit/job/torch/crew/representative
	name = OUTFIT_JOB_NAME("SolGov Representative")
	l_ear = /obj/item/device/radio/headset/headset_com
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/solgov
	suit = /obj/item/clothing/suit/storage/toggle/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/crew/representative
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher

/decl/hierarchy/outfit/job/torch/crew/command/sea/fleet
	name = OUTFIT_JOB_NAME("Senior Enlisted Advisor - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/sea
	id_type = /obj/item/weapon/card/id/torch/crew/sea
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer
	name = OUTFIT_JOB_NAME("Bridge Officer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/bridgeofficer
	pda_type = /obj/item/modular_computer/pda/heads
	l_ear = /obj/item/device/radio/headset/bridgeofficer

/decl/hierarchy/outfit/job/torch/crew/command/bridgeofficer/fleet
	name = OUTFIT_JOB_NAME("Bridge Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command
	shoes = /obj/item/clothing/shoes/dutyboots

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
	pda_type = /obj/item/modular_computer/pda/heads/ce

/decl/hierarchy/outfit/job/torch/crew/engineering/senior_engineer/fleet
	name = OUTFIT_JOB_NAME("Senior Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/engineering
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/engineering
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/torch/crew/engineering/engineer/fleet
	name = OUTFIT_JOB_NAME("Engineer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/engineering/contractor
	name = OUTFIT_JOB_NAME("Engineering Assistant")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/contractor/engineering
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/torch/crew/engineering/roboticist
	name = OUTFIT_JOB_NAME("Roboticist - Torch")
	uniform = /obj/item/clothing/under/rank/roboticist
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/torchroboticist
	id_type = /obj/item/weapon/card/id/torch/contractor/engineering/roboticist
	pda_type = /obj/item/modular_computer/pda/roboticist

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
	pda_type = /obj/item/modular_computer/pda/security

/decl/hierarchy/outfit/job/torch/crew/security/brig_officer/fleet
	name = OUTFIT_JOB_NAME("Brig Officer - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech
	name = OUTFIT_JOB_NAME("Forensic Technician - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/security/forensic
	pda_type = /obj/item/modular_computer/pda/forensics

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/contractor
	name = OUTFIT_JOB_NAME("Forensic Technician - Contractor")
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_trench/ft
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/clothing/accessory/badge/PI = 1)

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/fleet
	name = OUTFIT_JOB_NAME("Forensic Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/security/forensic_tech/agent
	name = OUTFIT_JOB_NAME("Forensic Technician - OCIE Agent")
	uniform = /obj/item/clothing/under/det/grey
	suit = /obj/item/clothing/suit/storage/toggle/agent_jacket
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/job/torch/crew/security/maa
	name = OUTFIT_JOB_NAME("Master at Arms")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/security
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/security
	pda_type = /obj/item/modular_computer/pda/security

/decl/hierarchy/outfit/job/torch/crew/security/maa/fleet
	name = OUTFIT_JOB_NAME("Master at Arms - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/security
	shoes = /obj/item/clothing/shoes/dutyboots

//Medical Outfits

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

/decl/hierarchy/outfit/job/torch/crew/medical/doctor
	name = OUTFIT_JOB_NAME("Corpsman")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_corpsman

/decl/hierarchy/outfit/job/torch/crew/medical/doctor/fleet
	name = OUTFIT_JOB_NAME("Corpsman - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/headset_corpsman

/decl/hierarchy/outfit/job/torch/crew/medical/doctor/medic
	name = OUTFIT_JOB_NAME("Corpsman - Medic")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/medical
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/headset_corpsman

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

/decl/hierarchy/outfit/job/torch/crew/medical/biomech
	name = OUTFIT_JOB_NAME("Biomechanical Engineer")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/torchroboticist
	id_type = /obj/item/weapon/card/id/torch/contractor/biomech
	pda_type = /obj/item/modular_computer/pda/roboticist

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
	pda_type = /obj/item/modular_computer/pda/chemistry
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
	name = OUTFIT_JOB_NAME("Deck Chief")
	l_ear = /obj/item/device/radio/headset/headset_deckofficer
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/supply/deckofficer
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/torch/crew/supply/deckofficer/fleet
	name = OUTFIT_JOB_NAME("Deck Chief - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/supply/tech
	name = OUTFIT_JOB_NAME("Deck Technician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/supply
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/torch/crew/supply/tech/fleet
	name = OUTFIT_JOB_NAME("Deck Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/supply/contractor
	name = OUTFIT_JOB_NAME("Supply Assistant")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/torch/contractor/supply
	pda_type = /obj/item/modular_computer/pda/cargo


//Service Outfits

/decl/hierarchy/outfit/job/torch/crew/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/torch/crew/service

/decl/hierarchy/outfit/job/torch/crew/service/janitor
	name = OUTFIT_JOB_NAME("Sanitation Technician - Torch")
	uniform = /obj/item/clothing/under/rank/janitor
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/torch/crew/service/janitor
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/torch/crew/service/janitor/ec
	name = OUTFIT_JOB_NAME("Sanitation Technician - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/service
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/service/janitor
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/torch/crew/service/janitor/fleet
	name = OUTFIT_JOB_NAME("Sanitation Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/service
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/service/cook
	name = OUTFIT_JOB_NAME("Cook - Torch")
	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/torch/crew/service/chef
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/torch/crew/service/cook/ec
	name = OUTFIT_JOB_NAME("Cook - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/service
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/service/chef
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/torch/crew/service/cook/fleet
	name = OUTFIT_JOB_NAME("Cook - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/service
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/crew/service/bartender
	name = OUTFIT_JOB_NAME("Bartender - Torch")
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/laceup
	id_type = /obj/item/weapon/card/id/torch/contractor/service/bartender
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/torch/crew/service/crewman
	name = OUTFIT_JOB_NAME("Crewman")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/torch/crew/service/crewman/fleet
	name = OUTFIT_JOB_NAME("Crewman - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet
	shoes = /obj/item/clothing/shoes/dutyboots

//Exploration Outfits
/decl/hierarchy/outfit/job/torch/crew/exploration/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/explorer
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/explorer
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/explorer

/decl/hierarchy/outfit/job/torch/crew/exploration/pathfinder
	name = OUTFIT_JOB_NAME("Pathfinder")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/exploration
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/pathfinder
	pda_type = /obj/item/modular_computer/pda/explorer
	l_ear = /obj/item/device/radio/headset/pathfinder

/decl/hierarchy/outfit/job/torch/crew/exploration/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/exploration
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/explorer
	pda_type = /obj/item/modular_computer/pda/explorer
	l_ear = /obj/item/device/radio/headset/exploration

/decl/hierarchy/outfit/job/torch/crew/exploration/pilot
	name = OUTFIT_JOB_NAME("Shuttle Pilot - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/exploration
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/pilot
	pda_type = /obj/item/modular_computer/pda/explorer
	l_ear = /obj/item/device/radio/headset/headset_pilot

/decl/hierarchy/outfit/job/torch/crew/exploration/pilot/fleet
	name = OUTFIT_JOB_NAME("Shuttle Pilot - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet

//Passenger Outfits

/decl/hierarchy/outfit/job/torch/passenger/research
	hierarchy_type = /decl/hierarchy/outfit/job/torch/passenger/research
	l_ear = /obj/item/device/radio/headset/torchnanotrasen

/decl/hierarchy/outfit/job/torch/passenger/research/nt_pilot //pending better uniform
	name = OUTFIT_JOB_NAME("Corporate Pilot")
	uniform = /obj/item/clothing/under/rank/ntpilot
	suit = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_pilot
	id_type = /obj/item/weapon/card/id/torch/passenger/research/nt_pilot

/decl/hierarchy/outfit/job/torch/passenger/pilot
	name = OUTFIT_JOB_NAME("Shuttle Pilot")
	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/headset_pilot
	id_type = /obj/item/weapon/card/id/torch/passenger/research/nt_pilot
	head = /obj/item/clothing/head/helmet/solgov/pilot

/decl/hierarchy/outfit/job/torch/passenger/research/scientist
	name = OUTFIT_JOB_NAME("Scientist - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research/scientist

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/solgov
	name = OUTFIT_JOB_NAME("Scientist - SCG")
	head = /obj/item/clothing/head/beret/solgov/research

/decl/hierarchy/outfit/job/torch/passenger/research/scientist/psych
	name = OUTFIT_JOB_NAME("Psychologist - Torch")
	uniform = /obj/item/clothing/under/rank/psych

/decl/hierarchy/outfit/job/torch/passenger/research/prospector
	name = OUTFIT_JOB_NAME("Prospector")
	uniform = /obj/item/clothing/under/rank/ntwork
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/passenger/research/mining
	pda_type = /obj/item/modular_computer/pda/science
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	l_ear = /obj/item/device/radio/headset/headset_mining

/decl/hierarchy/outfit/job/torch/passenger/research/prospector/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/torch/passenger/research/assist
	name = OUTFIT_JOB_NAME("Research Assistant - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research

/decl/hierarchy/outfit/job/torch/passenger/research/assist/solgov
	name = OUTFIT_JOB_NAME("Research Assistant - SCG")
	head = /obj/item/clothing/head/beret/solgov/research


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
	pda_type = /obj/item/modular_computer/pda
	id_type = /obj/item/weapon/card/id/torch/passenger

/decl/hierarchy/outfit/job/torch/passenger/passenger/journalist
	name = OUTFIT_JOB_NAME("Journalist - Torch")
	backpack_contents = list(/obj/item/device/camera/tvcamera = 1,
	/obj/item/clothing/accessory/badge/press = 1)

/decl/hierarchy/outfit/job/torch/passenger/passenger/investor
	name = OUTFIT_JOB_NAME("Investor - Torch")

/decl/hierarchy/outfit/job/torch/passenger/passenger/investor/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/storage/secure/briefcase/money/case = new(H.loc)
	H.put_in_hands(case)

/decl/hierarchy/outfit/job/torch/merchant
	name = OUTFIT_JOB_NAME("Merchant - Torch")
	uniform = /obj/item/clothing/under/color/black
	l_ear = null
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda
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

/decl/hierarchy/outfit/job/torch/ert
	name = OUTFIT_JOB_NAME("ERT - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat
	head = /obj/item/clothing/head/beret/solgov/fleet
	gloves = /obj/item/clothing/gloves/thick
	id_type = /obj/item/weapon/card/id/centcom/ERT
	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/job/torch/ert/leader
	name = OUTFIT_JOB_NAME("ERT Leader - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/command
	head = /obj/item/clothing/head/beret/solgov/fleet/command

//Army outfits
/decl/hierarchy/outfit/job/torch/army
	name = OUTFIT_JOB_NAME("SCGA Soldier - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/army
	head = /obj/item/clothing/head/solgov/utility/army
	back = /obj/item/weapon/storage/backpack/rucksack/green
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/job/torch/armyservice
	name = OUTFIT_JOB_NAME("SCGA Service - Torch")
	uniform = /obj/item/clothing/under/solgov/service/army
	head = /obj/item/clothing/head/solgov/service/army
	suit = /obj/item/clothing/suit/storage/solgov/service/army
	back = null
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/job/torch/armyservice/skirt
	name = OUTFIT_JOB_NAME("SCGA Service - Skirt")
	uniform = /obj/item/clothing/under/solgov/service/army/skirt

/decl/hierarchy/outfit/job/torch/armyservice/officer
	name = OUTFIT_JOB_NAME("SCGA Service - Officer")
	uniform = /obj/item/clothing/under/solgov/service/army/command
	head = /obj/item/clothing/head/solgov/service/army/command
	suit = /obj/item/clothing/suit/storage/solgov/service/army/command

/decl/hierarchy/outfit/job/torch/armyservice/officer/skirt
	name = OUTFIT_JOB_NAME("SCGA Service - Officer Skirt")
	uniform = /obj/item/clothing/under/solgov/service/army/command/skirt

/decl/hierarchy/outfit/job/torch/armydress
	name = OUTFIT_JOB_NAME("SCGA Dress - Torch")
	uniform = /obj/item/clothing/under/solgov/mildress/army
	head = /obj/item/clothing/head/solgov/dress/army
	suit = /obj/item/clothing/suit/dress/solgov/army
	back = null
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/job/torch/armydress/skirt
	name = OUTFIT_JOB_NAME("SCGA Dress - Skirt")
	uniform = /obj/item/clothing/under/solgov/mildress/army/skirt

/decl/hierarchy/outfit/job/torch/armydress/officer
	name = OUTFIT_JOB_NAME("SCGA Dress - Officer")
	uniform = /obj/item/clothing/under/solgov/mildress/army/command
	head = /obj/item/clothing/head/solgov/dress/army/command
	suit = /obj/item/clothing/suit/dress/solgov/army/command

/decl/hierarchy/outfit/job/torch/armydress/officer/skirt
	name = OUTFIT_JOB_NAME("SCGA Dress - Officer Skirt")
	uniform = /obj/item/clothing/under/solgov/mildress/army/command/skirt

/*
TERRAN OUTFITS
*/

/decl/hierarchy/outfit/job/terran/crew
	name = OUTFIT_JOB_NAME("Independent Navy - Utility")
	hierarchy_type = /decl/hierarchy/outfit/job/terran/crew
	uniform = /obj/item/clothing/under/terran/navy/utility
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/terran
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store

/decl/hierarchy/outfit/job/terran/crew/service
	name = OUTFIT_JOB_NAME("Independent Navy - Service")
	head = /obj/item/clothing/head/terran/navy/service
	uniform = /obj/item/clothing/under/terran/navy/service
	suit = /obj/item/clothing/suit/storage/terran/service/navy
	shoes = /obj/item/clothing/shoes/terran/service
	gloves = /obj/item/clothing/gloves/terran

/decl/hierarchy/outfit/job/terran/crew/service/command
	name = OUTFIT_JOB_NAME("Independent Navy - Service Command")
	head = /obj/item/clothing/head/terran/navy/service/command
	uniform = /obj/item/clothing/under/terran/navy/service/command
	suit = /obj/item/clothing/suit/storage/terran/service/navy/command

/decl/hierarchy/outfit/job/terran/crew/dress
	name = OUTFIT_JOB_NAME("Independent Navy - Dress")
	head = /obj/item/clothing/head/terran/navy/service
	uniform = /obj/item/clothing/under/terran/navy/service
	suit = /obj/item/clothing/suit/dress/terran/navy
	shoes = /obj/item/clothing/shoes/terran/service
	gloves = /obj/item/clothing/gloves/terran

/decl/hierarchy/outfit/job/terran/crew/dress/officer
	name = OUTFIT_JOB_NAME("Independent Navy - Officer")
	uniform = /obj/item/clothing/under/terran/navy/service
	suit = /obj/item/clothing/suit/dress/terran/navy/officer

/decl/hierarchy/outfit/job/terran/crew/dress/command
	name = OUTFIT_JOB_NAME("Independent Navy - Dress Command")
	head = /obj/item/clothing/head/terran/navy/service/command
	uniform = /obj/item/clothing/under/terran/navy/service/command
	suit = /obj/item/clothing/suit/dress/terran/navy/command

//Crew Research Oufits

/decl/hierarchy/outfit/job/torch/crew/research
	name = OUTFIT_JOB_NAME("Research Assistant - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/research
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/research
	pda_type = /obj/item/modular_computer/pda/science
	l_ear = /obj/item/device/radio/headset/torchnanotrasen

/decl/hierarchy/outfit/job/torch/crew/research/cso
	name = OUTFIT_JOB_NAME("Chief Science Officer - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/research
	l_ear = /obj/item/device/radio/headset/heads/torchntdirector
	id_type = /obj/item/weapon/card/id/torch/silver/research
	pda_type = /obj/item/modular_computer/pda/heads/rd

/decl/hierarchy/outfit/job/torch/crew/research/senior_scientist
	name = OUTFIT_JOB_NAME("Senior Scientist - Expeditionary Corps")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/officer/research
	id_type = /obj/item/weapon/card/id/torch/crew/research/senior_scientist

/decl/hierarchy/outfit/job/torch/crew/research/scientist
	name = OUTFIT_JOB_NAME("Scientist - Expeditionary Corps")
	id_type = /obj/item/weapon/card/id/torch/crew/research/scientist
 