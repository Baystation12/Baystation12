/decl/hvt_role/unathi
	name = "Kaahnepo"
	force_species = SPECIES_UNATHI
	description = "You are a Kaahnepo of your clan, a high standing member of the Moghes Hegemony. You are on this ship as part of a diplomatic mission between the Hegemony and SCGEC. Your clan holds something of worth to the EC, and this is their way of convincing your clan to work with them."
	allowed_bodyguards = list(
		/decl/hvt_role/bodyguard,
		/decl/hvt_role/bodyguard/unathi
	)
	outfit = /decl/hierarchy/outfit/hunter/vip/unathi

/decl/hvt_role/unathi/kaahnepo
	name = "Srr-Kaahnepo"
	description = "You are a Srr-Kaahnepo, a high ranking member of the Ssen-Uuma convent. You are on this ship as part of a diplomatic mission between the Convent and the SCG. Your clan is an important and stabilizing faction among the convent and the SCG would like to gain your clan's support."
	allowed_bodyguards = list(
		/decl/hvt_role/bodyguard,
		/decl/hvt_role/bodyguard/unathi,
		/decl/hvt_role/bodyguard/unathi/convent
	)

/decl/hvt_role/unathi/matriarch
	name = "Matriarch"
	force_gender = FEMALE
	description = "You are a matriarch of your clan, a high standing member of the Moghes Hegemony. You are on this ship as part of a diplomatic mission between the Hegemony and SCGEC. Your clan holds something of worth to the EC, and this is their way of convincing your clan to work with them."

/decl/hvt_role/bodyguard/unathi
	name = "Hegemony Bodyguard"
	description = "You are a bodyguard for your Matriarch/Kaahnepo. A skilled warrior among your clan, you were given the honor of going with your clan leader. Ensure that the safety of your Matriarch/Kaahnepo is kept, they represent your clan in more than just leadership after all."
	outfit = /decl/hierarchy/outfit/hunter/bodyguard/unathi
	allowed_leaders = list(
		/decl/hvt_role/unathi,
		/decl/hvt_role/unathi/kaahnepo,
		/decl/hvt_role/unathi/matriarch
	)

/decl/hvt_role/bodyguard/unathi/convent
	name = "Convent Bodyguard"
	description = "You are a bodyguard for your Srr-Kaahnepo. A high ranking soldier among the convent, you're charged with protecting your leader. Ensure that the safety of the Srr-Kaahnepo is kept, otherwise you'll likely face a court martial when you return."
	outfit = /decl/hierarchy/outfit/hunter/bodyguard/unathi/armoured

/decl/hierarchy/outfit/hunter/vip/unathi
	name = OUTFIT_JOB_NAME("Bounty Hunter VIP - Unathi")
	uniform = /obj/item/clothing/suit/unathi/robe
	suit = /obj/item/clothing/suit/unathi/mantle
	shoes = /obj/item/clothing/shoes/sandal

/decl/hierarchy/outfit/hunter/bodyguard/unathi
	name = OUTFIT_JOB_NAME("Bounty Hunter Bodyguard - Unathi")
	uniform = /obj/item/clothing/suit/unathi/robe
	shoes =   /obj/item/clothing/shoes/sandal
	suit =    /obj/item/clothing/suit/poncho/colored/red
	l_hand =  /obj/item/weapon/melee/energy/axe/ceremonial
	r_hand =  /obj/item/weapon/shield/energy
	holster = null

/decl/hierarchy/outfit/hunter/bodyguard/unathi/armoured
	name = OUTFIT_JOB_NAME("Bounty Hunter Bodyguard - Armoured Unathi")
	suit = /obj/item/weapon/rig/unathi/bodyguard
	r_hand = null

/obj/item/weapon/melee/energy/axe/ceremonial
	name = "ceremonial vibro-axe"
	desc = "A powerful melee weapon originating on Moghes, passed down through the clans."
	active_force = 40
	active_throwforce = 20
	force = 15
