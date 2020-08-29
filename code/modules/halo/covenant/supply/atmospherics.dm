
/decl/hierarchy/supply_pack/covenant_atmos
	name = "Atmospherics"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"
	containertype = /obj/structure/closet/crate/covenant



/* ATMOS SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_atmos/unggoy_tank
	name = "Unggoy Methane Tank (3)"
	contains = list(
		/obj/item/weapon/tank/methane/unggoy_internal = 1,
		/obj/item/weapon/tank/methane/unggoy_internal/red = 1,
		/obj/item/weapon/tank/methane/unggoy_internal/green = 1,
		/obj/item/weapon/tank/methane/unggoy_internal/blue = 1)
	cost = 450
	num_contained = 3
	containername = "\improper Unggoy Methane Tank crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/covenant_atmos/oxygen_tank
	name = "Portable oxygen tank (3)"
	contains = list(/obj/item/weapon/tank/air/covenant = 3)
	cost = 400
	num_contained = 3
	containername = "\improper Oxygen tank crate"

/decl/hierarchy/supply_pack/covenant_atmos/canister_oxygen
	name = "Oxygen Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen = 1)
	cost = 250
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/canister_air
	name = "Air Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/air = 1)
	cost = 250
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/canister_nitrogen
	name = "Nitrogen Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen = 1)
	cost = 250
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/canister_carbon_dioxide
	name = "Carbon Dioxide Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide = 1)
	cost = 250
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/canister_sleeping
	name = "N2O Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent = 1)
	cost = 250
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/canister_phoron
	name = "Phoron Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron = 1)
	cost = 250
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/canister_empty
	name = "Empty Canister"
	contains = list(/obj/machinery/portable_atmospherics/canister = 1)
	cost = 200
	containertype = null

/decl/hierarchy/supply_pack/covenant_atmos/internals
	name = "Internals crate (3)"
	contains = list(/obj/item/weapon/tank/emergency/oxygen/covenant = 3, /obj/item/clothing/mask/breath = 3)
	cost = 150
