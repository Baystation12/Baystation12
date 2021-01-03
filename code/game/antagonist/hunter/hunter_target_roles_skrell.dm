/decl/hvt_role/skrell
	name = "Krri'Gli Drive Inspector"
	description = "You are a high-ranking Skrellian bluespace engineer aboard for diagnostics and telemetry gathering for the bluespace drive."
	force_species = SPECIES_SKRELL
	outfit = /decl/hierarchy/outfit/hunter/vip/skrell
	allowed_bodyguards = list(
		/decl/hvt_role/bodyguard,
		/decl/hvt_role/bodyguard/skrell
	)

/decl/hvt_role/skrell/observer
	name = "Kal'lo Observer"
	description = "You are a Qerr-Katish delegate from a city state on Qerr'Balak, on board to monitor your city-states investment and tour the facilities."

/decl/hvt_role/skrell/liaison
	name = "Qala'oa Liaison"
	description = "You are a Raskinta from Qala'oa aboard to observe vessel operations and learn from the Captain about human vessel leadership."

/decl/hvt_role/bodyguard/skrell
	name = "Warbleguard"
	description = "You are a Warble who guards a Warble."
	outfit = /decl/hierarchy/outfit/hunter/bodyguard/skrell
	force_species = SPECIES_SKRELL
	allowed_leaders = list(
		/decl/hvt_role/skrell,
		/decl/hvt_role/skrell/observer,
		/decl/hvt_role/skrell/liaison
	)

/decl/hierarchy/outfit/hunter/vip/skrell
	name = OUTFIT_JOB_NAME("Bounty Hunter VIP - Skrell")
	uniform = /obj/item/clothing/under/kimono
	suit = /obj/item/clothing/suit/poncho/colored/blue
	r_ear = /obj/item/clothing/ears/skrell/chain/bluejewels
	shoes = /obj/item/clothing/shoes/blue

/decl/hierarchy/outfit/hunter/bodyguard/skrell
	name = OUTFIT_JOB_NAME("Bounty Hunter Bodyguard - Skrell")
	uniform = /obj/item/clothing/under/skrelljumpsuit
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/thick/swat/skrell
	r_ear = /obj/item/clothing/ears/skrell/chain/silver
	l_pocket = /obj/item/clothing/accessory/badge/tags/skrell
	l_hand = /obj/item/weapon/gun/energy/gun/skrell
