/obj/item/clothing/suit/armor/swat/battle
	name = "battle armor"
	desc = "Highly protective armour."
	armor = list(melee = 75, bullet = 80, laser = 55,energy = 15, bomb = 70, bio = 40, rad = 60)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_flags = THICKMATERIAL
	icon_state = "heavy"

/obj/item/clothing/suit/armor/swat/battle/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/head/helmet/swat/battle
	name = "battle helmet"
	desc = "A highly protective helmet."
	armor = list(melee = 65, bullet = 65, laser = 40,energy = 10, bomb = 60, bio = 10, rad = 10)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT

/obj/item/clothing/under/rank/security/battle
	name = "navy outfit"
	desc = "A lightweight padded suit worn aboard battle ships."
	armor = list(melee = 10, bullet = 10, laser = 10,energy = 10, bomb = 25, bio = 5, rad = 5)
	icon_state = "navyutility"
	worn_state = "navyutility"

/obj/item/clothing/under/rank/security/battle/captain
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon_state = "confed"
	item_state = "confed"
	worn_state = "confed"

/obj/item/clothing/suit/storage/toggle/pilotcoat
	name = "pilot jacket"
	desc = "A thick, well-worn jacket."
	icon_state = "bomber"
	item_state = "bomber"
	icon_open = "bomber_open"
	icon_closed = "bomber"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS|LOWER_TORSO
	min_cold_protection_temperature = T0C - 20
	siemens_coefficient = 0.7
	armor = list(melee = 25, bullet = 30, laser = 10, energy = 10, bomb = 30, bio = 10, rad = 10)

/obj/item/clothing/head/ushanka/battle
	name = "worn ushanka"
	desc = "A padded ushanka. Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	flags_inv = HIDEEARS
	armor = list(melee = 15, bullet = 30, laser = 50, energy = 40, bomb = 50, bio = 40, rad = 10)

/obj/item/clothing/head/helmet/space/syndicate/black/engie/battle
	name = "courier helmet"
	desc = "A space-worthy bomb-resistant suit."
	armor = list(melee = 15, bullet = 15, laser = 15,energy = 15, bomb = 95, bio = 100, rad = 25)

/obj/item/clothing/head/helmet/space/syndicate/black/engie/battle/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/suit/space/syndicate/black/engie/battle
	name = "courier suit"
	desc = "A space-worthy bomb-resistant suit."
	armor = list(melee = 15, bullet = 15, laser = 15,energy = 15, bomb = 95, bio = 100, rad = 100)

/obj/item/clothing/suit/space/syndicate/black/engie/battle/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/suit/storage/toggle/fr_jacket/battle
	armor = list(melee = 20, bullet = 40, laser = 45, energy = 40, bomb = 65, bio = 75, rad = 10)

/obj/item/clothing/suit/armor/hos/battle
	name = "officer coat"
	desc = "A highly protective coat marking the high distinction of an officer."
	armor = list(melee = 40, bullet = 40, laser = 40,energy = 40, bomb = 60, bio = 25, rad = 15)

/obj/item/clothing/head/HoS/battle
	armor = list(melee = 30, bullet = 40, laser = 30,energy = 30, bomb = 50, bio = 15, rad = 10)
	desc = "A protective hat for officers."
	name = "Officer Hat"

/obj/item/clothing/head/dress/fleet/command/battle
	name = "Commander Hat"
	desc = "A protective hat, fit for the commander themself"
	armor = list(melee = 50, bullet = 55, laser = 60, energy = 70, bomb = 60, bio = 30, rad = 20)

/decl/hierarchy/outfit/job/space_battle
	name = "Default Battle Gear"
	hierarchy_type = /decl/hierarchy/outfit/job/space_battle
	l_ear = null
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel_sec
	backpack_contents = list(/obj/item/device/flashlight/flare = 1,\
							 /obj/item/weapon/crowbar = 1, \
							 /obj/item/weapon/book/manual/frontier = 1)
	uniform = /obj/item/clothing/under/rank/security/battle
	pda_slot = null
	pda_type = null
	var/job_type = null

	equip_id(var/mob/living/carbon/human/H, var/rank, var/assignment)
		sleep(0)
		if(!id_slot)
			return
		var/team = H.mind ? H.mind.team : 0
		switch(team)
			if(1)
				team = "team_one"
			if(2)
				team = "team_two"
			if(3)
				team = "team_three"
			if(4)
				team = "team_four"
		var/new_id_type = text2path("/obj/item/weapon/card/id/space_battle/[team][job_type ? "/[job_type]" : ""]") // /obj/item/weapon/card/id/space_battle/team_one/medic
		var/obj/item/weapon/card/id/W = new new_id_type(H)
		if(id_desc)
			W.desc = id_desc
		if(rank)
			W.rank = rank
		if(assignment)
			W.assignment = assignment
		H.set_id_info(W)
		if(H.equip_to_slot_or_del(W, id_slot))
			return W

	equip(mob/living/carbon/human/H, var/rank, var/assignment)
		..()
		spawn(10)
			var/obj/item/organ/internal/stack/S = H.internal_organs_by_name[BP_STACK]
			if(H && H.mind && H.mind.team && S)
				S.team = H.mind.team

/decl/hierarchy/outfit/job/space_battle/sailor
	name = OUTFIT_JOB_NAME("Space Sailor")
	glasses = /obj/item/clothing/glasses/sunglasses


/decl/hierarchy/outfit/job/space_battle/captain
	name = OUTFIT_JOB_NAME("Space Commander")
	glasses = /obj/item/clothing/glasses/sunglasses
	suit = /obj/item/clothing/suit/storage/vest/nt/hos
	backpack_contents = null
	l_hand = /obj/item/weapon/gun/projectile/pirate/battle
	belt = /obj/item/weapon/storage/belt/ammo_pouch
	uniform = /obj/item/clothing/under/rank/security/battle/captain
	head = /obj/item/clothing/head/dress/fleet/command/battle
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	job_type = "commander"


/decl/hierarchy/outfit/job/space_battle/engineer
	name = OUTFIT_JOB_NAME("Space Engineer")
	belt = /obj/item/weapon/storage/belt/utility/full
	backpack = /obj/item/weapon/storage/backpack/industrial
	head = /obj/item/clothing/head/hardhat
	gloves = /obj/item/clothing/gloves/insulated
	suit = /obj/item/clothing/suit/storage/hazardvest
	job_type = "engineer"

/decl/hierarchy/outfit/job/space_battle/medic
	name = "Space Doctor"
	suit = /obj/item/clothing/suit/storage/toggle/fr_jacket/battle
	l_hand = /obj/item/weapon/storage/firstaid/adv
	glasses = /obj/item/clothing/glasses/hud/health
	job_type = "medic"

/decl/hierarchy/outfit/job/space_battle/officer
	name = "Space Officer"
	suit = /obj/item/clothing/suit/armor/hos/battle
	head = /obj/item/clothing/head/HoS/battle
	job_type = "officer"

/decl/hierarchy/outfit/job/space_battle/courier
	name = "Space Courier"
	suit = /obj/item/clothing/suit/space/syndicate/black/engie/battle
	head = /obj/item/clothing/head/helmet/space/syndicate/black/engie/battle
	l_pocket = /obj/item/weapon/screwdriver
	job_type = "courier"

/decl/hierarchy/outfit/job/space_battle/marine
	name = "Space Marine"
	suit = /obj/item/clothing/suit/armor/swat/battle
	head = /obj/item/clothing/head/helmet/swat/battle
	belt = /obj/item/weapon/storage/belt/arrow
	backpack = null
	satchel_one = null
	backpack_contents = null
	l_hand = /obj/item/weapon/gun/launcher/crossbow
	mask = /obj/item/clothing/mask/gas/syndicate
	l_pocket = /obj/item/weapon/tank/emergency/oxygen/double
	job_type = "security"


/decl/hierarchy/outfit/job/space_battle/pilot
	name = "Space Pirate"
	suit = /obj/item/clothing/suit/storage/toggle/pilotcoat
	head = /obj/item/clothing/head/ushanka/battle
	job_type = "pilot"
