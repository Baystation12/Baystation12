/decl/hierarchy/supply_pack/science
	name = "Research - Exploration"

/decl/hierarchy/supply_pack/science/chemistry_dispenser
	name = "Equipment - Chemical Reagent dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser{anchored = FALSE}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "reagent dispenser crate"

/decl/hierarchy/supply_pack/science/coolanttank
	name = "Liquid - Coolant tank"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/decl/hierarchy/supply_pack/science/robotics
	name = "Parts - Robotics"
	contains = list(/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/storage/toolbox/electrical,
					/obj/item/device/flash = 4,
					/obj/item/cell/high = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "robotics assembly crate"
	access = access_robotics

/decl/hierarchy/supply_pack/science/phoron
	name = "Parts - Phoron device kit"
	contains = list(/obj/item/tank/phoron = 3,
					/obj/item/device/assembly/igniter = 3,
					/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/device/assembly/timer = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "phoron assembly crate"
	access = access_tox_storage

/decl/hierarchy/supply_pack/science/scanner_module
	name = "Electronics - Reagent scanner modules"
	contains = list(/obj/item/stock_parts/computer/scanner/reagent = 4)
	cost = 20
	containername = "reagent scanner module crate"

/decl/hierarchy/supply_pack/science/minergear
	name = "Shaft miner equipment"
	contains = list(/obj/item/storage/backpack/industrial,
					/obj/item/storage/backpack/satchel/eng,
					/obj/item/device/radio/headset/headset_cargo,
					/obj/item/clothing/under/rank/miner,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/black,
					/obj/item/device/scanner/gas,
					/obj/item/storage/ore,
					/obj/item/device/flashlight/lantern,
					/obj/item/shovel,
					/obj/item/pickaxe,
					/obj/item/device/scanner/mining,
					/obj/item/clothing/glasses/material,
					/obj/item/clothing/glasses/meson)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "shaft miner equipment crate"
	access = access_mining

/decl/hierarchy/supply_pack/science/flamps
	num_contained = 3
	contains = list(/obj/item/device/flashlight/lamp/floodlamp,
					/obj/item/device/flashlight/lamp/floodlamp/green)
	name = "Equipment - Flood lamps"
	cost = 20
	containername = "flood lamp crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/science/illuminate
	name = "Gear - Illumination grenades"
	contains = list(/obj/item/grenade/light = 8)
	cost = 20
	containername = "illumination grenade crate"

/decl/hierarchy/supply_pack/science/anomaly_crate
	name = "Equipment - Anomaly Container"
	cost = 20
	contains = list(/obj/structure/anomaly_container)
	containertype = /obj/structure/largecrate
	containername = "anomaly container crate"
