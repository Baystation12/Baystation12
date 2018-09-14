/decl/hierarchy/supply_pack/science
	name = "Research - Exploration"

/decl/hierarchy/supply_pack/science/chemistry_dispenser
	name = "Equipment - Chemical Reagent dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "reagent dispenser crate"

/decl/hierarchy/supply_pack/science/virus
	name = "Samples - Virus sample crate"
	contains = list(/obj/item/weapon/virusdish/random = 4)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Virus sample crate"
	access = access_cmo

/decl/hierarchy/supply_pack/science/coolanttank
	name = "Liquid - Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "\improper coolant tank crate"

/decl/hierarchy/supply_pack/science/mecha_odysseus
	name = "Electronics - Circuit Crate (\"Odysseus\")"
	contains = list(/obj/item/weapon/circuitboard/mecha/odysseus/peripherals, //TEMPORARY due to lack of circuitboard printer,
					/obj/item/weapon/circuitboard/mecha/odysseus/main) //TEMPORARY due to lack of circuitboard printer
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper \"Odysseus\" Circuit Crate"
	access = access_robotics

/decl/hierarchy/supply_pack/science/robotics
	name = "Parts - Robotics assembly crate"
	contains = list(/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/device/flash = 4,
					/obj/item/weapon/cell/high = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "\improper Robotics assembly"
	access = access_robotics

/decl/hierarchy/supply_pack/science/phoron
	name = "Parts - Phoron assembly crate"
	contains = list(/obj/item/weapon/tank/phoron = 3,
					/obj/item/device/assembly/igniter = 3,
					/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/device/assembly/timer = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "\improper Phoron assembly crate"
	access = access_tox_storage

/decl/hierarchy/supply_pack/science/scanner_module
	name = "Electronics - Reagent scanner module crate"
	contains = list(/obj/item/weapon/computer_hardware/scanner/reagent = 4)
	cost = 20
	containername = "\improper Reagent scanner module crate"

/decl/hierarchy/supply_pack/science/minergear
	name = "Shaft miner equipment"
	contains = list(/obj/item/weapon/storage/backpack/industrial,
					/obj/item/weapon/storage/backpack/satchel_eng,
					/obj/item/device/radio/headset/headset_cargo,
					/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/black,
					/obj/item/device/analyzer,
					/obj/item/weapon/storage/ore,
					/obj/item/device/flashlight/lantern,
					/obj/item/weapon/shovel,
					/obj/item/weapon/pickaxe,
					/obj/item/weapon/mining_scanner,
					/obj/item/clothing/glasses/material,
					/obj/item/clothing/glasses/meson)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Shaft miner equipment"
	access = access_mining

/decl/hierarchy/supply_pack/science/flamps
	num_contained = 3
	contains = list(/obj/item/device/flashlight/lamp/floodlamp,
					/obj/item/device/flashlight/lamp/floodlamp/green)
	name = "Flood lamps"
	cost = 20
	containername = "\improper Flood lamp crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/science/illuminate
	name = "Illumination grenades"
	contains = list(/obj/item/weapon/grenade/light = 8)
	cost = 20
	containername = "\improper Illumination grenade crate"