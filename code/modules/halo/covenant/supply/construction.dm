
/decl/hierarchy/supply_pack/covenant_construction
	name = "Construction"
	//hierarchy_type = /decl/hierarchy/supply_pack/covenant
	//access = access_covenant
	contraband = "Covenant"
	containertype = /obj/structure/closet/crate/covenant



/* CONSTRUCTION SUPPLY PACKS */

/decl/hierarchy/supply_pack/covenant_construction/plasma_drill
	name = "Plasma Drill"
	contains = list(/obj/item/weapon/pickaxe/plasma_drill = 1)
	cost = 750
	containername = "\improper Plasma Drill crate"

/decl/hierarchy/supply_pack/covenant_construction/toolbox
	name = "Tool kit"
	contains = list(/obj/item/weapon/storage/toolbox/covenant_mech = 1,
		/obj/item/weapon/storage/toolbox/covenant_elec = 1,
		/obj/item/weapon/storage/belt/covenant = 1)
	cost = 150
	containername = "\improper Tool kit"

/decl/hierarchy/supply_pack/covenant_construction/toolbox
	name = "Plasma charges (2)"
	contains = list(/obj/item/weapon/plastique/covenant = 2)
	cost = 550
	containername = "\improper Plasma charge crate"

/decl/hierarchy/supply_pack/covenant_construction/nanolaminate
	name = "Nanolaminate (50 x 2)"
	contains = list(/obj/item/stack/material/nanolaminate/fifty = 2)
	cost = 800
	containername = "\improper Nanolaminate crate"
