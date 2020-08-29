
/decl/hierarchy/supply_pack/covenant_equipment
	name = "Equipment"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"
	containertype = /obj/structure/closet/crate/covenant



/* MISC SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_equipment/weapon_rack
	name = "Weapon charging rack"
	contains = list(/obj/structure/weapon_rack = 1)
	cost = 2000
	containertype = null

/decl/hierarchy/supply_pack/covenant_equipment/barricades_energy
	name = "Energy barricades"
	contains = list(/obj/item/energybarricade = 3)
	cost = 1000
	containername = "\improper Energy barricades crate"

/decl/hierarchy/supply_pack/covenant_equipment/barricades_vacuum
	name = "Vacuum energy barricades"
	contains = list(/obj/item/energybarricade/vacuum_shield = 3)
	cost = 500
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
	containername = "\improper Medical supplies (mixed) crate"

/decl/hierarchy/supply_pack/covenant_equipment/cleanbots
	name = "Cleaning drone"
	contains = list(
		/mob/living/bot/cleanbot/covenant = 1)
	cost = 150
	containertype = null

/decl/hierarchy/supply_pack/covenant_equipment/ghost
	name = "Type-32 \"Ghost\" Rapid Assault Vehicle"
	contains = list(/obj/vehicles/ghost = 1)
	cost = 2500
	containertype = null

/decl/hierarchy/supply_pack/covenant_equipment/floodlight
	name = "Area Illuminator"
	contains = list(/obj/machinery/floodlight/covenant = 1)
	cost = 200
	containertype = null

/decl/hierarchy/supply_pack/covenant_equipment/artifact_pinpointer
	name = "Artifact Pinpointer (2)"
	contains = list(/obj/item/weapon/pinpointer/artifact = 2)
	cost = 250
	containername = "\improper Artifact Pinpointers crate"

/decl/hierarchy/supply_pack/covenant_equipment/scanpoint_locator
	name = "Scanpoint locator (2)"
	contains = list(/obj/item/weapon/pinpointer/scanpoint_locator = 2)
	cost = 350
	containername = "\improper Scanpoint locator crate"

/decl/hierarchy/supply_pack/covenant_equipment/lights
	name = "Handheld lights (4)"
	contains = list(
		/obj/item/device/flashlight/covenant = 1,
		/obj/item/device/flashlight/glowstick/covenant = 1)
	num_contained = 4
	cost = 100
	containername = "\improper Handheld lights crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/covenant_equipment/bomb_pinpointer
	name = "Bomb Plant Pinpointer (2)"
	contains = list(/obj/item/weapon/pinpointer/advpinpointer/bombplantlocator = 2)
	cost = 250
	containername = "\improper Bomb Plant Pinpointer crate"

/decl/hierarchy/supply_pack/covenant_equipment/stationery
	name = "Stationery kit"
	contains = list(
		/obj/item/weapon/clipboard = 2,
		/obj/item/weapon/folder = 2,
		/obj/item/weapon/pen = 2,
		/obj/item/weapon/paper_bin = 1)
	cost = 50
	containername = "\improper Stationery crate"


/decl/hierarchy/supply_pack/covenant_equipment/bomb_pinpointer
	name = "Drop Pod Beacons (3)"
	contains = list(/obj/item/drop_pod_beacon/covenant = 3)
	cost = 650
	containername = "\improper Drop Pod Beacon crate"
