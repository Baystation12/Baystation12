
/decl/hierarchy/supply_pack/covenant_equipment
	name = "Equipment"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"



/* MISC SUPPLY PACKS */
/*
/decl/hierarchy/supply_pack/covenant_equipment/belts
	name = "Storage belts (mixed)"
	contains = list(
		/obj/item/weapon/storage/belt/covenant_ammo = 1,
		/obj/item/weapon/storage/belt/covenant_medic = 1,
		/obj/item/clothing/accessory/storage/bandolier/covenant = 1)
	cost = 500
	containername = "\improper Storage belts (mixed) crate"
	containertype = /obj/structure/closet/crate/covenant
*/
/decl/hierarchy/supply_pack/covenant_equipment/weapon_rack
	name = "Weapon charging rack"
	contains = list(/obj/structure/weapon_rack = 1)
	cost = 2000
	containertype = null

/decl/hierarchy/supply_pack/covenant_equipment/barricades_energy
	name = "Energy barricades"
	contains = list(/obj/item/energybarricade = 3)
	cost = 1000
	containertype = /obj/structure/closet/crate/covenant
	containername = "\improper Energy barricades crate"

/decl/hierarchy/supply_pack/covenant_equipment/barricades_vacuum
	name = "Vacuum energy barricades"
	contains = list(/obj/item/energybarricade/vacuum_shield = 3)
	cost = 500
	containertype = /obj/structure/closet/crate/covenant
	containername = "\improper Vacuum energy barricades crate"

/decl/hierarchy/supply_pack/covenant_equipment/bnet_transmitter
	name = "Portable Battlenet Transmitter"
	contains = list(/obj/machinery/overmap_comms/receiver/battlenet = 1)
	cost = 1000
	containertype = null

/decl/hierarchy/supply_pack/covenant_equipment/medical_mixed
	name = "Medical supplies (mixed)"
	contains = list(
		/obj/item/weapon/storage/firstaid/regular/covenant = 2,
		/obj/item/weapon/storage/firstaid/combat/covenant = 2,
		/obj/item/weapon/storage/firstaid/unsc/cov = 2,
		/obj/item/weapon/storage/firstaid/combat/unsc/cov = 2)
	cost = 1250
	containertype = /obj/structure/closet/crate/covenant
	containername = "\improper Medical supplies (mixed) crate"

/decl/hierarchy/supply_pack/covenant_equipment/cleanbots
	name = "Cleaning drone"
	contains = list(
		/mob/living/bot/cleanbot/covenant = 1)
	cost = 150
	containertype = null///obj/structure/closet/crate/covenant
	containername = "\improper Cleaning drones crate"

/decl/hierarchy/supply_pack/covenant_equipment/ghost
	name = "Type-32 \"Ghost\" Rapid Assault Vehicle"
	contains = list(/obj/vehicles/ghost = 1)
	cost = 2500
	containertype = null
