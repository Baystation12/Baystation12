///Job Outfits

/*
sierra OUTFITS
Keeping them simple for now, just spawning with basic EC uniforms, and pretty much no gear. Gear instead goes in lockers. Keep this in mind if editing.
*/

/singleton/hierarchy/outfit/job/sierra
	name = OUTFIT_JOB_NAME("Sierra Outfit")
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
//	pda_type = /obj/item/modular_computer/pda
	pda_type = null //we are using PDAs from loadout
	pda_slot = slot_l_store

/singleton/hierarchy/outfit/job/sierra/crew
	name = OUTFIT_JOB_NAME("Sierra Crew Outfit")
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew
	uniform = /obj/item/clothing/under/solgov/utility
	shoes = /obj/item/clothing/shoes/dutyboots

/singleton/hierarchy/outfit/job/sierra/passenger
	name = OUTFIT_JOB_NAME("Sierra Passenger")
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/passenger
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id/sierra/passenger)


	///////////
	//COMMAND//
	///////////

/singleton/hierarchy/outfit/job/sierra/crew/command
	name = OUTFIT_JOB_NAME("Sierra Command Outfit")
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/command
	l_ear = /obj/item/device/radio/headset/headset_com
//	pda_type = /obj/item/modular_computer/pda/heads

/singleton/hierarchy/outfit/job/sierra/crew/command/captain
	name = OUTFIT_JOB_NAME("Captain - Sierra")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/captain
	l_ear = /obj/item/device/radio/headset/heads/sierra_captain
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/caphat
	id_types = list(/obj/item/card/id/sierra/gold)
//	pda_type = /obj/item/modular_computer/pda/captain

/singleton/hierarchy/outfit/job/sierra/crew/command/captain/New()
	..()
	BACKPACK_OVERRIDE_COMMAND

/singleton/hierarchy/outfit/job/sierra/crew/command/hop
	name = OUTFIT_JOB_NAME("Head of Personnel - Sierra")
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	l_ear = /obj/item/device/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/sierra/silver)
//	pda_type = /obj/item/modular_computer/pda/heads/hop

/singleton/hierarchy/outfit/job/sierra/crew/command/hop/New()
	..()
	BACKPACK_OVERRIDE_COMMAND

/singleton/hierarchy/outfit/job/sierra/crew/research/rd
	name = OUTFIT_JOB_NAME("Research Director - Sierra")
	l_ear = /obj/item/device/radio/headset/heads/rd
	uniform = /obj/item/clothing/under/rank/research_director
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/rd/nanotrasen
	shoes = /obj/item/clothing/shoes/brown
	id_types = list(/obj/item/card/id/sierra/silver/research)
//	pda_type = /obj/item/modular_computer/pda/heads/rd

/singleton/hierarchy/outfit/job/sierra/crew/command/rd/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/singleton/hierarchy/outfit/job/sierra/crew/command/cmo
	name = OUTFIT_JOB_NAME("Chief Medical Officer - Sierra")
	l_ear  =/obj/item/device/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/chief_medical_officer
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	shoes = /obj/item/clothing/shoes/brown
	id_types = list(/obj/item/card/id/sierra/silver/medical)
//	pda_type = /obj/item/modular_computer/pda/heads/cmo
	pda_slot = slot_l_store

/singleton/hierarchy/outfit/job/sierra/crew/command/cmo/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/singleton/hierarchy/outfit/job/sierra/crew/command/chief_engineer
	name = OUTFIT_JOB_NAME("Chief Engineer - Sierra")
	uniform = /obj/item/clothing/under/rank/chief_engineer
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/heads/ce
	id_types = list(/obj/item/card/id/sierra/silver/engineering)
//	pda_type = /obj/item/modular_computer/pda/heads/ce
	pda_slot = slot_l_store
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL
	belt = /obj/item/storage/belt/utility/chief

/singleton/hierarchy/outfit/job/sierra/crew/command/chief_engineer/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/singleton/hierarchy/outfit/job/sierra/crew/command/hos
	name = OUTFIT_JOB_NAME("Head of Security - Sierra")
	l_ear = /obj/item/device/radio/headset/heads/hos
	uniform = /obj/item/clothing/under/rank/head_of_security/corp
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/sierra/silver/security)
//	pda_type = /obj/item/modular_computer/pda/heads/hos

/singleton/hierarchy/outfit/job/sierra/crew/command/hos/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/singleton/hierarchy/outfit/job/sierra/crew/command/iaa
	name = OUTFIT_JOB_NAME("Internal Affairs Agent - Sierra")
	l_ear = /obj/item/device/radio/headset/ia
	uniform = /obj/item/clothing/under/rank/internalaffairs/plain/nt
	suit = /obj/item/clothing/suit/storage/toggle/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/sierra/crew/liaison)
//	pda_type = /obj/item/modular_computer/pda/heads/paperpusher
	backpack_contents = list(/obj/item/clothing/accessory/badge/nanotrasen = 1)

/singleton/hierarchy/outfit/job/sierra/crew/command/adjutant
	name = OUTFIT_JOB_NAME("Adjutant")
	uniform = /obj/item/clothing/under/rank/adjutant
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/adjutant
	id_types = list(/obj/item/card/id/sierra/crew/adjutant)

	///////////////
	//ENGINEERING//
	///////////////

/singleton/hierarchy/outfit/job/sierra/crew/engineering
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/engineering
	l_ear = /obj/item/device/radio/headset/headset_eng
//	pda_type = /obj/item/modular_computer/pda/engineering
	pda_slot = slot_l_store
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/sierra/crew/engineering/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/singleton/hierarchy/outfit/job/sierra/crew/engineering/senior_engineer
	name = OUTFIT_JOB_NAME("Senior Engineer")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id_types = list(/obj/item/card/id/sierra/crew/engineering/senior)
//	pda_type = /obj/item/modular_computer/pda/heads/ce

/singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer - Sierra")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/workboots
	id_types = list(/obj/item/card/id/sierra/crew/engineering)

/singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/atmos
	name = OUTFIT_JOB_NAME("Engineer (Atmos) - Sierra")
	uniform = /obj/item/clothing/under/rank/atmospheric_technician

/singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/maints
	name = OUTFIT_JOB_NAME("Engineer (Maints) - Sierra")
	uniform = /obj/item/clothing/under/hazard

/singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/tcomms
	name = OUTFIT_JOB_NAME("Engineer (Tcomms) - Sierra")
	uniform = /obj/item/clothing/under/rank/dispatch
	shoes = /obj/item/clothing/shoes/brown
	id_types = list(/obj/item/card/id/sierra/crew/engineering/comms)

/singleton/hierarchy/outfit/job/sierra/crew/engineering/engineer/trainee
	name = OUTFIT_JOB_NAME("Engineer Trainee - Sierra")
	id_types = list(/obj/item/card/id/sierra/crew/engineering/trainee)

	////////////
	//SECURITY//
	////////////

/singleton/hierarchy/outfit/job/sierra/crew/security
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/security
	l_ear = /obj/item/device/radio/headset/headset_sec
//	pda_type = /obj/item/modular_computer/pda/security
	pda_slot = slot_l_store

/singleton/hierarchy/outfit/job/sierra/crew/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/singleton/hierarchy/outfit/job/sierra/crew/security/warden
	name = OUTFIT_JOB_NAME("Warden - Sierra")
	uniform = /obj/item/clothing/under/rank/warden/corp
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/sierra/crew/security/warden)

/singleton/hierarchy/outfit/job/sierra/crew/security/detective
	name = OUTFIT_JOB_NAME("Detective - Sierra")
	head = /obj/item/clothing/head/det
	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_trench
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/sierra/crew/security/detective)
//	pda_type = /obj/item/modular_computer/pda/forensics

/singleton/hierarchy/outfit/job/sierra/crew/security/officer
	name = OUTFIT_JOB_NAME("Security Officer - Sierra")
	uniform = /obj/item/clothing/under/rank/security/corp
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/sierra/crew/security)

/singleton/hierarchy/outfit/job/sierra/crew/security/assist
	name = OUTFIT_JOB_NAME("Cadet - Sierra")
	uniform = /obj/item/clothing/under/rank/security
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/sierra/crew/security/cadet)

	///////////
	//MEDICAL//
	///////////

/singleton/hierarchy/outfit/job/sierra/crew/medical
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white
//	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store

/singleton/hierarchy/outfit/job/sierra/crew/medical/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/singleton/hierarchy/outfit/job/sierra/crew/medical/senior
	name = OUTFIT_JOB_NAME("Surgeon - Sierra")
	uniform = /obj/item/clothing/under/rank/medical/scrubs
	id_types = list(/obj/item/card/id/sierra/crew/medical/senior)

/singleton/hierarchy/outfit/job/sierra/crew/medical/senior/traumasurgeon
	name = OUTFIT_JOB_NAME("Trauma Surgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/blue

/singleton/hierarchy/outfit/job/sierra/crew/medical/senior/xenosurgeon
	name = OUTFIT_JOB_NAME("Xenosurgeon")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/purple

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor
	name = OUTFIT_JOB_NAME("Doctor")
	uniform = /obj/item/clothing/under/rank/medical
	id_types = list(/obj/item/card/id/sierra/crew/medical)

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/orderly
	name = OUTFIT_JOB_NAME("Orderly")
	uniform = /obj/item/clothing/under/rank/orderly

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/mortus
	name = OUTFIT_JOB_NAME("Mortician")
	uniform = /obj/item/clothing/under/rank/medical/scrubs/black

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/paramedic
	name = OUTFIT_JOB_NAME("Paramedic - Sierra")
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	shoes = /obj/item/clothing/shoes/jackboots
	l_hand = /obj/item/storage/firstaid/adv
	belt = /obj/item/storage/belt/medical/emt
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/nurse
	name = OUTFIT_JOB_NAME("Nurse - Sierra")
	suit = null

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/nurse/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		if(prob(50))
			uniform = /obj/item/clothing/under/rank/nursesuit
		else
			uniform = /obj/item/clothing/under/rank/nurse
		head = /obj/item/clothing/head/nursehat
	else
		uniform = /obj/item/clothing/under/rank/medical/scrubs/purple
		head = null


/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/chemist
	name = OUTFIT_JOB_NAME("Chemist - Sierra")
	uniform = /obj/item/clothing/under/rank/chemist
//	pda_type = /obj/item/modular_computer/pda/chemistry
	id_types = list(/obj/item/card/id/sierra/crew/medical/chemist)

/singleton/hierarchy/outfit/job/sierra/crew/medical/doctor/chemist/New()
	..()
	BACKPACK_OVERRIDE_CHEMISTRY

/singleton/hierarchy/outfit/job/sierra/crew/medical/counselor
	name = OUTFIT_JOB_NAME("Counselor - Sierra")
	uniform = /obj/item/clothing/under/rank/psych
	id_types = list(/obj/item/card/id/sierra/crew/medical/counselor)

/singleton/hierarchy/outfit/job/sierra/crew/medical/counselor/equip_ids(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	. = ..()
	var/obj/item/card/id/foundation_civilian/regis_card = new
	if(rank)
		regis_card.rank = rank
	if(assignment)
		regis_card.assignment = assignment
	H.set_id_info(regis_card)
	H.equip_to_slot_or_store_or_drop(regis_card)

/singleton/hierarchy/outfit/job/sierra/crew/medical/counselor/mentalist
	name = OUTFIT_JOB_NAME("Counselor - Mentalist - Sierra")
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup

	/////////
	//CARGO//
	/////////

/singleton/hierarchy/outfit/job/sierra/crew/supply
	l_ear = /obj/item/device/radio/headset/headset_cargo
	shoes = /obj/item/clothing/shoes/brown
//	pda_type = /obj/item/modular_computer/pda/cargo
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/supply

/singleton/hierarchy/outfit/job/sierra/crew/supply/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/singleton/hierarchy/outfit/job/sierra/crew/supply/quartermaster
	name = OUTFIT_JOB_NAME("Quartermaster")
	l_ear = /obj/item/device/radio/headset/sierra_quartermaster
	uniform = /obj/item/clothing/under/rank/cargo
	id_types = list(/obj/item/card/id/sierra/crew/supply/quartermaster)

/singleton/hierarchy/outfit/job/sierra/crew/supply/tech
	name = OUTFIT_JOB_NAME("Cargo Technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_types = list(/obj/item/card/id/sierra/crew/supply)

/singleton/hierarchy/outfit/job/sierra/crew/supply/prospector
	name = OUTFIT_JOB_NAME("Prospector")
	uniform = /obj/item/clothing/under/rank/ntwork
	shoes = /obj/item/clothing/shoes/workboots
	id_types = list(/obj/item/card/id/sierra/crew/supply/mining)
	l_ear = /obj/item/device/radio/headset/headset_mining
	flags = OUTFIT_FLAGS_JOB_DEFAULT | OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/sierra/crew/supply/assistant
	name = OUTFIT_JOB_NAME("Cargo Assistant")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_types = list(/obj/item/card/id/sierra/crew/supply)

	///////////
	//SERVICE//
	///////////

/singleton/hierarchy/outfit/job/sierra/crew/service
	l_ear = /obj/item/device/radio/headset/headset_service
	shoes = /obj/item/clothing/shoes/black
//	pda_type = /obj/item/modular_computer/pda
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/service

/singleton/hierarchy/outfit/job/sierra/crew/service/chief_steward
	name = OUTFIT_JOB_NAME("Chief Steward - Sierra")
	l_ear = /obj/item/device/radio/headset/sierra_chief_steward
	uniform = /obj/item/clothing/under/rank/chef
	id_types = list(/obj/item/card/id/sierra/crew/service/chief_steward)
	backpack_contents = list(/obj/item/music_tape/custom = 1)

/singleton/hierarchy/outfit/job/sierra/crew/service/janitor
	name = OUTFIT_JOB_NAME("Janitor - Sierra")
	uniform = /obj/item/clothing/under/rank/janitor
	id_types = list(/obj/item/card/id/sierra/crew/service/janitor)

/singleton/hierarchy/outfit/job/sierra/crew/service/cook
	name = OUTFIT_JOB_NAME("Cook - Sierra")
	uniform = /obj/item/clothing/under/rank/chef
	id_types = list(/obj/item/card/id/sierra/crew/service/cook)

/singleton/hierarchy/outfit/job/sierra/crew/service/steward
	name = OUTFIT_JOB_NAME("Steward - Sierra")
	uniform = /obj/item/clothing/under/waiter
	id_types = list(/obj/item/card/id/sierra/crew/service/steward)

/singleton/hierarchy/outfit/job/sierra/crew/service/bartender
	name = OUTFIT_JOB_NAME("Bartender - Sierra")
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/sierra/crew/service/bartender)
	backpack_contents = list(/obj/item/storage/music_tape_holder = 1)

/singleton/hierarchy/outfit/job/sierra/crew/service/chaplain
	name = OUTFIT_JOB_NAME("Chaplain - Sierra")
	uniform = /obj/item/clothing/under/rank/chaplain
	id_types = list(/obj/item/card/id/sierra/crew/service/chaplain)

/singleton/hierarchy/outfit/job/sierra/crew/service/actor
	name = OUTFIT_JOB_NAME("Actor - Sierra")
	uniform = /obj/item/clothing/under/redcoat
	id_types = list(/obj/item/card/id/sierra/crew/service/actor)
	shoes = /obj/item/clothing/shoes/laceup

	///////////////
	//EXPLORATION//
	///////////////

/singleton/hierarchy/outfit/job/sierra/crew/exploration
	shoes = /obj/item/clothing/shoes/dutyboots
//	pda_type = /obj/item/modular_computer/pda/explorer
	l_ear = /obj/item/device/radio/headset/exploration

/singleton/hierarchy/outfit/job/sierra/crew/exploration/New()
	..()
	backpack_overrides[/singleton/backpack_outfit/backpack]      = /obj/item/storage/backpack/explorer
	backpack_overrides[/singleton/backpack_outfit/satchel]       = /obj/item/storage/backpack/satchel_explorer
	backpack_overrides[/singleton/backpack_outfit/messenger_bag] = /obj/item/storage/backpack/messenger/explorer

/singleton/hierarchy/outfit/job/sierra/crew/exploration/el
	name = OUTFIT_JOB_NAME("Exploration Leader")
	uniform = /obj/item/clothing/under/rank/field
	id_types = list(/obj/item/card/id/sierra/crew/exploration_leader)
	l_ear = /obj/item/device/radio/headset/exploration_leader

/singleton/hierarchy/outfit/job/sierra/crew/exploration/explorer
	name = OUTFIT_JOB_NAME("Explorer")
	uniform = /obj/item/clothing/under/rank/field
	id_types = list(/obj/item/card/id/sierra/crew/explorer)

/singleton/hierarchy/outfit/job/sierra/crew/exploration/pilot
	name = OUTFIT_JOB_NAME("Expeditionary Pilot")
	uniform = /obj/item/clothing/under/rank/field
	id_types = list(/obj/item/card/id/sierra/crew/pilot)
	l_ear = /obj/item/device/radio/headset/headset_pilot

/singleton/hierarchy/outfit/job/sierra/crew/exploration/medic
	name = OUTFIT_JOB_NAME("Field Medic")
	uniform = /obj/item/clothing/under/rank/field
	id_types = list(/obj/item/card/id/sierra/crew/field_medic)
	l_ear = /obj/item/device/radio/headset/exploration/medic

/singleton/hierarchy/outfit/job/sierra/crew/exploration/engineer
	name = OUTFIT_JOB_NAME("Field Engineer")
	uniform = /obj/item/clothing/under/rank/field
	id_types = list(/obj/item/card/id/sierra/crew/field_engineer)
	l_ear = /obj/item/device/radio/headset/exploration/engineer

	////////////
	//RESEARCH//
	////////////

/singleton/hierarchy/outfit/job/sierra/crew/research
	hierarchy_type = /singleton/hierarchy/outfit/job/sierra/crew/research
//	pda_type = /obj/item/modular_computer/pda/science
	l_ear = /obj/item/device/radio/headset/headset_sci

/singleton/hierarchy/outfit/job/sierra/crew/research/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/singleton/hierarchy/outfit/job/sierra/crew/research/senior_scientist
	name = OUTFIT_JOB_NAME("Senior Researcher")
	uniform = /obj/item/clothing/under/rank/scientist/executive/nanotrasen
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science/nanotrasen
	shoes = /obj/item/clothing/shoes/white
//	pda_type = /obj/item/modular_computer/pda/heads/rd
	id_types = list(/obj/item/card/id/sierra/crew/research/senior_scientist)

/singleton/hierarchy/outfit/job/sierra/crew/research/scientist
	name = OUTFIT_JOB_NAME("Scientist - Sierra")
	uniform = /obj/item/clothing/under/rank/scientist/nanotrasen
	shoes = /obj/item/clothing/shoes/white
	id_types = list(/obj/item/card/id/sierra/crew/research/scientist)

/singleton/hierarchy/outfit/job/sierra/crew/research/roboticist
	name = OUTFIT_JOB_NAME("Roboticist - Sierra")
	uniform = /obj/item/clothing/under/rank/roboticist
	shoes = /obj/item/clothing/shoes/black
	l_ear = /obj/item/device/radio/headset/sierra_roboticist
	id_types = list(/obj/item/card/id/sierra/crew/research/roboticist)
//	pda_type = /obj/item/modular_computer/pda/roboticist

/singleton/hierarchy/outfit/job/sierra/crew/research/assist
	name = OUTFIT_JOB_NAME("Research Assistant - Sierra")
	uniform = /obj/item/clothing/under/rank/scientist/nanotrasen
	shoes = /obj/item/clothing/shoes/white
	id_types = list(/obj/item/card/id/sierra/crew/research)

/singleton/hierarchy/outfit/job/sierra/crew/research/assist/testsubject
	name = OUTFIT_JOB_NAME("Testing Assistant")
	uniform = /obj/item/clothing/under/rank/ntwork

	//////////////
	//PASSENGERS//
	//////////////

/singleton/hierarchy/outfit/job/sierra/passenger/passenger
	name = OUTFIT_JOB_NAME("Passenger - Sierra")
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
//	pda_type = /obj/item/modular_computer/pda
	id_types = list(/obj/item/card/id/sierra/passenger)

/singleton/hierarchy/outfit/job/sierra/passenger/passenger/journalist
	name = OUTFIT_JOB_NAME("Journalist - Sierra")
	backpack_contents = list(/obj/item/device/camera/tvcamera = 1,
	/obj/item/clothing/accessory/badge/press = 1)

	/////////
	//OTHER//
	/////////

/singleton/hierarchy/outfit/job/sierra/ert
	name = OUTFIT_JOB_NAME("ERT - Sierra")
	uniform = /obj/item/clothing/under/color/grey
	head = /obj/item/clothing/head/beret/centcom/officer
	gloves = /obj/item/clothing/gloves/thick/combat
	id_types = list(/obj/item/card/id/centcom/ERT)
//	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/combat

/singleton/hierarchy/outfit/job/sierra/ert/leader
	name = OUTFIT_JOB_NAME("ERT Leader - Sierra")
	head = /obj/item/clothing/head/beret/centcom/captain
