
/obj/item/weapon/storage/belt/covenant_medic/mobilespawn_medic
	startswith = list(\
	/obj/item/weapon/storage/firstaid/unsc/cov,
	/obj/item/weapon/storage/firstaid/unsc/cov,
	/obj/item/weapon/storage/firstaid/combat/unsc/cov,
	)

/obj/item/weapon/storage/backpack/sangheili/mobilespawn_engineer
	startswith = list(\
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/nanolaminate/fifty,
	/obj/item/weapon/armor_patch,
	/obj/item/weapon/grenade/plasma,
	)

/decl/hierarchy/outfit/mobilespawn_unggoy //Likely won't use this, use major, grenadier and medic instead.
	name = "Unggoy Soldier (Minor)"

	l_ear = /obj/item/device/radio/headset/covenant
	r_ear = /obj/item/weapon/reagent_containers/syringe/biofoam
	glasses = /obj/item/clothing/glasses/hud/tactical/covenant
	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness
	back = /obj/item/weapon/tank/methane/unggoy_internal
	uniform = /obj/item/clothing/under/unggoy_internal
	belt = /obj/item/weapon/gun/energy/plasmapistol
	mask = /obj/item/clothing/mask/rebreather
	r_pocket = /obj/item/weapon/grenade/plasma
	l_pocket = /obj/item/drop_pod_beacon/covenant

	flags = 0

/decl/hierarchy/outfit/mobilespawn_unggoy/major
	name = "Unggoy Soldier (Major)"

	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness/major

	l_pocket = /obj/item/weapon/reagent_containers/syringe/biofoam

/decl/hierarchy/outfit/mobilespawn_unggoy_grenadier
	name = "Unggoy Soldier (Grenadier)"

	l_ear = /obj/item/device/radio/headset/covenant
	r_ear = /obj/item/weapon/reagent_containers/syringe/biofoam
	glasses = /obj/item/clothing/glasses/hud/tactical/covenant
	suit = /obj/item/clothing/suit/armor/special/unggoy_combat_harness
	back = /obj/item/weapon/tank/methane/unggoy_internal
	uniform = /obj/item/clothing/under/unggoy_internal
	mask = /obj/item/clothing/mask/rebreather
	l_hand = /obj/item/weapon/grenade/plasma
	r_hand = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma
	l_pocket = /obj/item/weapon/grenade/plasma

	flags = 0

/decl/hierarchy/outfit/mobilespawn_unggoy/medic
	name = "Unggoy Soldier (Medic)"

	belt = /obj/item/weapon/storage/belt/covenant_medic/mobilespawn_medic
	l_hand = /obj/item/weapon/gun/energy/plasmapistol

	r_pocket = /obj/item/weapon/grenade/smokebomb

/decl/hierarchy/outfit/mobilespawn_unggoy/engineer
	name = "Unggoy Soldier (Engineer)"

	l_hand = /obj/item/weapon/storage/backpack/sangheili/mobilespawn_engineer

	r_pocket = /obj/item/weapon/armor_patch
	l_pocket = /obj/item/weapon/grenade/smokebomb

/obj/item/weapon/storage/belt/marine_ammo/mobilespawn_ma5
	startswith = list(\
	/obj/item/ammo_magazine/m762_ap/MA5B,
	/obj/item/ammo_magazine/m762_ap/MA5B,
	/obj/item/ammo_magazine/m762_ap/MA5B,
	/obj/item/ammo_magazine/m762_ap/MA5B,
	/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe
	)

/obj/item/weapon/storage/belt/marine_medic/mobilespawn_medic
	startswith = list(\
	/obj/item/weapon/storage/firstaid/unsc,
	/obj/item/weapon/storage/firstaid/unsc,
	/obj/item/weapon/storage/firstaid/combat/unsc,
	/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5
	)

/obj/item/weapon/storage/backpack/marine/mobilespawn_engineer
	startswith = list(\
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/glass/reinforced/fifty,
	/obj/item/ammo_magazine/m762_ap/MA5B,
	/obj/item/ammo_magazine/m762_ap/MA5B,
	/obj/item/ammo_magazine/m762_ap/MA5B
	)

/obj/item/weapon/mop/mobilespawn_janitor
	name = "Modified Mop"
	desc = "This mop ssems to have been reinforced and modified to provide it with... A sharp edge?"
	edge = 1
	force = 30
	parry_projectiles = 1

/obj/item/weapon/storage/belt/marine_ammo/mobilespawn_janitor
	name = "Cleanliness Storage Belt"
	desc = "Some madman has modified the ammo pouches to store spray bottles and specifically, cleaning grenades."

	can_hold = list(/obj/item/weapon/grenade/chem_grenade/cleaner,/obj/item/weapon/reagent_containers/spray/cleaner)
	startswith = list(\
	/obj/item/weapon/grenade/chem_grenade/cleaner,
	/obj/item/weapon/grenade/chem_grenade/cleaner,
	/obj/item/weapon/reagent_containers/spray/cleaner,
	/obj/item/weapon/reagent_containers/spray/cleaner,
	/obj/item/weapon/reagent_containers/spray/cleaner,
	/obj/item/weapon/reagent_containers/spray/cleaner
	)

/decl/hierarchy/outfit/job/mobilespawn_marine
	name = "UNSC Marine (MA5B)"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	r_ear = /obj/item/weapon/reagent_containers/syringe/biofoam
	mask = /obj/item/clothing/mask/marine
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	back = /obj/item/weapon/gun/projectile/ma5b_ar
	suit_store = /obj/item/weapon/gun/projectile/m6d_magnum
	belt = /obj/item/weapon/storage/belt/marine_ammo/mobilespawn_ma5
	gloves = /obj/item/clothing/gloves/thick/unsc
	l_pocket =/obj/item/weapon/grenade/frag/m9_hedp
	r_pocket = /obj/item/weapon/armor_patch
	//I'm using the L/R hands for items that are intended to go in their armour.//
	l_hand = /obj/item/weapon/grenade/frag/m9_hedp
	r_hand = /obj/item/drop_pod_beacon

	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e2, /obj/item/clothing/accessory/badge/tags)

	flags = 0

/decl/hierarchy/outfit/job/mobilespawn_marine/engineer
	name = "UNSC Marine (Engineer)"

	belt = /obj/item/weapon/storage/belt/utility/full
	suit_store = /obj/item/weapon/gun/projectile/ma5b_ar
	back = /obj/item/weapon/storage/backpack/marine/mobilespawn_engineer

	l_pocket = /obj/item/weapon/armor_patch
	r_pocket = /obj/item/weapon/armor_patch

/decl/hierarchy/outfit/job/mobilespawn_marine/medic
	name = "UNSC Marine (Medic)"

	head = /obj/item/clothing/head/helmet/marine/medic
	suit = /obj/item/clothing/suit/storage/marine/medic
	suit_store = /obj/item/weapon/gun/projectile/m7_smg
	belt = /obj/item/weapon/storage/belt/marine_medic/mobilespawn_medic
	l_pocket =/obj/item/weapon/grenade/smokebomb
	r_pocket = /obj/item/weapon/grenade/smokebomb

/decl/hierarchy/outfit/job/mobilespawn_janitor
	name = "UNSC Janitor"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	r_ear = /obj/item/weapon/reagent_containers/syringe/biofoam

	head = /obj/item/clothing/head/soft/purple
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/rank/janitor
	belt = /obj/item/weapon/storage/belt/marine_ammo/mobilespawn_janitor
	shoes = /obj/item/clothing/shoes/marine
	l_pocket =/obj/item/weapon/grenade/chem_grenade/cleaner
	r_pocket = /obj/item/weapon/grenade/chem_grenade/cleaner

	l_hand = /obj/item/weapon/mop/mobilespawn_janitor

	flags = 0

/obj/item/weapon/storage/belt/marine_ammo/mobilespawn_ma3
	startswith = list(\
	/obj/item/ammo_magazine/m762_ap/MA3,
	/obj/item/ammo_magazine/m762_ap/MA3,
	/obj/item/ammo_magazine/m762_ap/MA3,
	/obj/item/ammo_magazine/m762_ap/MA3,
	/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe
	)

/obj/item/weapon/storage/backpack/marine/mobilespawn_engineer_innie
	startswith = list(\
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/glass/reinforced/fifty,
	/obj/item/ammo_magazine/m762_ap/MA3,
	/obj/item/ammo_magazine/m762_ap/MA3,
	/obj/item/ammo_magazine/m762_ap/MA3
	)

/obj/item/clothing/head/helmet/gladiator/combat_ready
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	armor_thickness = 20

/obj/item/clothing/under/gladiator/combat_ready
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 40, bomb = 30, bio = 0, rad = 0)
	armor_thickness = 20

/decl/hierarchy/outfit/job/mobilespawn_innie
	name = "Insurrectionist (MA3)"

	l_ear = /obj/item/device/radio/headset/insurrection
	r_ear = /obj/item/weapon/reagent_containers/syringe/biofoam
	mask = /obj/item/clothing/mask/balaclava/tactical
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/innie/jumpsuit
	shoes = /obj/item/clothing/shoes/innie_boots/light/brown
	head = /obj/item/clothing/head/helmet/innie/heavy/brown
	suit = /obj/item/clothing/suit/storage/innie/light/brown
	back = /obj/item/weapon/gun/projectile/ma5b_ar/MA3
	suit_store = /obj/item/weapon/gun/projectile/m6d_magnum
	belt = /obj/item/weapon/storage/belt/marine_ammo/mobilespawn_ma3
	gloves = /obj/item/clothing/gloves/thick/unsc
	l_pocket =/obj/item/weapon/grenade/frag/m9_hedp
	r_pocket = /obj/item/weapon/armor_patch
	//I'm using the L/R hands for items that are intended to go in their armour.//
	l_hand = /obj/item/weapon/grenade/frag/m9_hedp
	r_hand = /obj/item/weapon/grenade/smokebomb

	flags = 0

/decl/hierarchy/outfit/job/mobilespawn_innie/engineer
	name = "Insurrectionist Engineer"

	belt = /obj/item/weapon/storage/belt/utility/full
	suit_store = /obj/item/weapon/gun/projectile/ma5b_ar/MA3
	back = /obj/item/weapon/storage/backpack/marine/mobilespawn_engineer_innie

	l_pocket = /obj/item/weapon/armor_patch
	r_pocket = /obj/item/weapon/armor_patch

/decl/hierarchy/outfit/job/mobilespawn_innie/medic
	name = "Insurrectionist Medic"

	shoes = /obj/item/clothing/shoes/innie_boots/light/white
	head = /obj/item/clothing/head/helmet/innie/heavy/white
	suit = /obj/item/clothing/suit/storage/innie/light/white
	suit_store = /obj/item/weapon/gun/projectile/m7_smg
	belt = /obj/item/weapon/storage/belt/marine_medic/mobilespawn_medic
	l_pocket =/obj/item/weapon/grenade/smokebomb
	r_pocket = /obj/item/weapon/grenade/smokebomb

/decl/hierarchy/outfit/job/mobilespawn_gladiator
	name = "Insurrectionist Gladiator"

	l_ear = /obj/item/device/radio/headset/insurrection
	r_ear = /obj/item/weapon/reagent_containers/syringe/biofoam

	head = /obj/item/clothing/head/helmet/gladiator/combat_ready
	uniform = /obj/item/clothing/under/gladiator/combat_ready

	l_hand = /obj/item/weapon/material/sword
	r_hand = /obj/item/weapon/material/twohanded/spear
	back = /obj/item/weapon/material/twohanded/spear

	l_pocket =/obj/item/weapon/grenade/smokebomb
	r_pocket = /obj/item/weapon/grenade/smokebomb