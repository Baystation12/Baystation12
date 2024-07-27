/singleton/hierarchy/supply_pack/science
	name = "Research - Exploration"

/singleton/hierarchy/supply_pack/science/chemistry_dispenser
	name = "Equipment - Chemical Reagent dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser{anchored = FALSE}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "reagent dispenser crate"

/singleton/hierarchy/supply_pack/science/coolanttank
	name = "Liquid - Coolant tank"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/singleton/hierarchy/supply_pack/science/flamps
	num_contained = 3
	contains = list(/obj/item/device/flashlight/lamp/floodlamp,
					/obj/item/device/flashlight/lamp/floodlamp/green)
	name = "Equipment - Flood lamps"
	cost = 20
	containername = "flood lamp crate"
	supply_method = /singleton/supply_method/randomized

/singleton/hierarchy/supply_pack/science/illuminate
	name = "Gear - Illumination grenades"
	contains = list(/obj/item/grenade/light = 8)
	cost = 20
	containername = "illumination grenade crate"

/singleton/hierarchy/supply_pack/science/anomaly_crate
	name = "Equipment - Anomaly Container"
	cost = 20
	contains = list(/obj/machinery/anomaly_container)
	containertype = /obj/structure/largecrate
	containername = "anomaly container crate"

/singleton/hierarchy/supply_pack/science/stasiscage_crate
	name = "Equipment - Stasis Cage"
	cost = 20
	contains = list(/obj/machinery/stasis_cage)
	containertype = /obj/structure/largecrate
	containername = "stasis cage crate"
