//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

/obj/effect/landmark/corpse
	name = "Unknown"
	var/decl/hierarchy/outfit/corpse_outfit = /decl/hierarchy/outfit/corpse
	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/species = SPECIES_HUMAN

/obj/effect/landmark/corpse/Initialize()
	createCorpse()
	. = ..()

/obj/effect/landmark/corpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	M.set_species(species)
	M.real_name = src.name
	M.adjustOxyLoss(M.maxHealth)//cease life functions
	M.setBrainLoss(M.maxHealth)
	var/obj/item/organ/internal/heart/corpse_heart = M.internal_organs_by_name[BP_HEART]
	corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much
	corpse_outfit = outfit_by_type(corpse_outfit)
	corpse_outfit.equip(M)
	//removes spawning survival kit. Find better way to do it
	var/obj/item/weapon/storage/box/survival/SB = locate() in get_turf(src)
	if (SB)
		qdel(SB)
	scramble(1,M,100)//randomizes appearence, not sure how to add random hairstyle yet
	M.h_style = random_hair_style(M.gender, species)
	M.f_style = random_facial_hair_style(M.gender, species)
	qdel(src)

/decl/hierarchy/outfit/corpse
	name = "Basic corpse outfit datum"
// I'll work on making a list of corpses people request for maps, or that I think will be commonly used. Syndicate operatives for example.
/obj/effect/landmark/corpse/syndicatesoldier
	name = "Syndicate Operative"
	corpse_outfit = /decl/hierarchy/outfit/corpse/syndicatesoldier

/decl/hierarchy/outfit/corpse/syndicatesoldier
	name = "Dead Syndicate Operative - Soldier"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear =  /obj/item/device/radio/headset
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/swat
	back = /obj/item/weapon/storage/backpack
	id_type = /obj/item/weapon/card/id/syndicate
	id_desc = "Syndicate Operative"
	id_slot = slot_wear_id

/obj/effect/landmark/corpse/syndicatecommando
	name = "Syndicate Commando"
	corpse_outfit = /decl/hierarchy/outfit/corpse/syndicatecommando

/decl/hierarchy/outfit/corpse/syndicatecommando
	name = "Dead Syndicate Operative - Commando"
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/void/merc
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear =  /obj/item/device/radio/headset
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	back = /obj/item/weapon/tank/jetpack/oxygen
	l_pocket = /obj/item/weapon/tank/emergency/oxygen
	id_type = /obj/item/weapon/card/id/syndicate
	id_desc = "Syndicate Operative"
	id_slot = slot_wear_id

///////////Civilians//////////////////////

/obj/effect/landmark/corpse/chef
	name = "Chef"
	corpse_outfit = /decl/hierarchy/outfit/corpse/chef

/decl/hierarchy/outfit/corpse/chef
	name = "Dead Chef"
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef/classic
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/chefhat
	back = /obj/item/weapon/storage/backpack
	l_ear =  /obj/item/device/radio/headset

/obj/effect/landmark/corpse/doctor
	name = "Doctor"
	corpse_outfit = /decl/hierarchy/outfit/corpse/doctor

/decl/hierarchy/outfit/corpse/doctor
	name = "Dead Doctor"
	l_ear =  /obj/item/device/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	back = /obj/item/weapon/storage/backpack/medic
	l_pocket = /obj/item/device/flashlight/pen
	shoes = /obj/item/clothing/shoes/black

/obj/effect/landmark/corpse/engineer
	name = "Engineer"
	corpse_outfit = /decl/hierarchy/outfit/corpse/engineer

/decl/hierarchy/outfit/corpse/engineer
	name = "Dead Engineer"
	l_ear =  /obj/item/device/radio/headset/headset_eng
	uniform = /obj/item/clothing/under/rank/engineer
	back = /obj/item/weapon/storage/backpack/industrial
	shoes = /obj/item/clothing/shoes/orange
	belt = /obj/item/weapon/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/insulated
	head = /obj/item/clothing/head/hardhat

/obj/effect/landmark/corpse/engineer/rig
	corpse_outfit = /decl/hierarchy/outfit/corpse/engineer/rig

/decl/hierarchy/outfit/corpse/engineer/rig
	name = "Dead Engineer- RIG"
	suit = /obj/item/clothing/suit/space/void/engineering
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/void/engineering

/obj/effect/landmark/corpse/clown
	name = "Clown"
	corpse_outfit = /decl/hierarchy/outfit/corpse/clown

/decl/hierarchy/outfit/corpse/clown
	name = "Dead Clown"
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	l_ear =  /obj/item/device/radio/headset
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/weapon/bikehorn
	back = /obj/item/weapon/storage/backpack/clown

/obj/effect/landmark/corpse/scientist
	name = "Scientist"
	corpse_outfit = /decl/hierarchy/outfit/corpse/scientist

/decl/hierarchy/outfit/corpse/scientist
	name = "Dead Scientist"
	l_ear =  /obj/item/device/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/scientist
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	back = /obj/item/weapon/storage/backpack
	shoes = /obj/item/clothing/shoes/white

/obj/effect/landmark/corpse/miner
	name = "Miner"
	corpse_outfit = /decl/hierarchy/outfit/corpse/miner

/decl/hierarchy/outfit/corpse/miner
	name = "Dead Miner"
	l_ear =  /obj/item/device/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/miner
	gloves = /obj/item/clothing/gloves/thick
	back = /obj/item/weapon/storage/backpack/industrial
	shoes = /obj/item/clothing/shoes/black

/obj/effect/landmark/corpse/miner/rig
	corpse_outfit = /decl/hierarchy/outfit/corpse/miner/rig

/decl/hierarchy/outfit/corpse/miner/rig
	name = "Dead Miner - RIG"
	suit = /obj/item/clothing/suit/space/void/mining
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/void/mining

/////////////////Officers//////////////////////

/obj/effect/landmark/corpse/bridgeofficer
	name = "Bridge Officer"
	corpse_outfit = /decl/hierarchy/outfit/corpse/bridgeofficer

/decl/hierarchy/outfit/corpse/bridgeofficer
	name = "Dead Bridge Officer"
	l_ear =  /obj/item/device/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/rank/centcom_officer
	suit = /obj/item/clothing/suit/armor/bulletproof
	shoes = /obj/item/clothing/shoes/black
	glasses = /obj/item/clothing/glasses/sunglasses

/obj/effect/landmark/corpse/commander
	name = "Commander"
	corpse_outfit = /decl/hierarchy/outfit/corpse/commander

/decl/hierarchy/outfit/corpse/commander
	name = "Dead Commander"
	uniform = /obj/item/clothing/under/rank/centcom_captain
	suit = /obj/item/clothing/suit/armor/bulletproof
	l_ear =  /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	head = /obj/item/clothing/head/centhat
	gloves = /obj/item/clothing/gloves/thick/swat
	shoes = /obj/item/clothing/shoes/swat
	l_pocket = /obj/item/weapon/flame/lighter/zippo

/obj/effect/landmark/corpse/pirate
	name = "Pirate"
	corpse_outfit = /decl/hierarchy/outfit/corpse/pirate

/decl/hierarchy/outfit/corpse/pirate
	name = "Dead pirate"
	uniform = /obj/item/clothing/under/pirate
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/eyepatch
	head = /obj/item/clothing/head/bandana

/obj/effect/landmark/corpse/pirate/ranged
	name = "Pirate Gunner"
	corpse_outfit = /decl/hierarchy/outfit/corpse/pirate/ranged

/decl/hierarchy/outfit/corpse/pirate/ranged
	name = "Dead pirate - ranged"
	suit = /obj/item/clothing/suit/pirate
	head = /obj/item/clothing/head/pirate

/obj/effect/landmark/corpse/russian
	name = "Russian"
	corpse_outfit = /decl/hierarchy/outfit/corpse/russian

/decl/hierarchy/outfit/corpse/russian
	name = "Dead russian"
	uniform = /obj/item/clothing/under/soviet
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/bearpelt

/obj/effect/landmark/corpse/russian/ranged
	corpse_outfit = /decl/hierarchy/outfit/corpse/russian/ranged

/decl/hierarchy/outfit/corpse/russian/ranged
	name = "Dead russian - ranged"
	head = /obj/item/clothing/head/ushanka
