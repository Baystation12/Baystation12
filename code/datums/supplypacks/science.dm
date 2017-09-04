/decl/hierarchy/supply_pack/science
	name = "Science"

/decl/hierarchy/supply_pack/science/virus
	name = "Virus sample crate"
	contains = list(/obj/item/weapon/virusdish/random = 4)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Virus sample crate"
	access = access_cmo

/decl/hierarchy/supply_pack/science/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "\improper coolant tank crate"

/decl/hierarchy/supply_pack/science/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(/obj/item/weapon/book/manual/ripley_build_and_repair,
					/obj/item/weapon/circuitboard/mecha/ripley/main, //TEMPORARY due to lack of circuitboard printer,
					/obj/item/weapon/circuitboard/mecha/ripley/peripherals) //TEMPORARY due to lack of circuitboard printer
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper APLU \"Ripley\" Circuit Crate"
	access = access_robotics

/decl/hierarchy/supply_pack/science/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(/obj/item/weapon/circuitboard/mecha/odysseus/peripherals, //TEMPORARY due to lack of circuitboard printer,
					/obj/item/weapon/circuitboard/mecha/odysseus/main) //TEMPORARY due to lack of circuitboard printer
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper \"Odysseus\" Circuit Crate"
	access = access_robotics

/decl/hierarchy/supply_pack/science/phoron
	name = "Phoron assembly crate"
	contains = list(/obj/item/weapon/tank/phoron = 3,
					/obj/item/device/assembly/igniter = 3,
					/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/device/assembly/timer = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "\improper Phoron assembly crate"
	access = access_tox_storage
