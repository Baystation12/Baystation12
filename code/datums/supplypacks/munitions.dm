/decl/hierarchy/supply_pack/munition
	name = "Ship Munitions"
	containertype = /obj/structure/largecrate
	containername = "mass driver munition crate"

/decl/hierarchy/supply_pack/munition/md_slug
	name = "Ammo - Mass Driver Slug"
	contains = list(/obj/structure/ship_munition/md_slug)
	cost = 50

/decl/hierarchy/supply_pack/munition/ap_slug
	name = "Ammo - Armor Piercing Mass Driver Slug"
	contains = list(/obj/structure/ship_munition/ap_slug)
	cost = 60

/decl/hierarchy/supply_pack/munition/fire
	name = "Ammo - disperser-FR1-ENFER charge"
	contains = list(/obj/structure/ship_munition/disperser_charge/fire)
	cost = 40

/decl/hierarchy/supply_pack/munition/emp
	name = "Ammo - disperser-EM2-QUASAR charge"
	contains = list(/obj/structure/ship_munition/disperser_charge/emp)
	cost = 40

/decl/hierarchy/supply_pack/munition/mining
	name = "Ammo - disperser-MN3-BERGBAU charge"
	contains = list(/obj/structure/ship_munition/disperser_charge/mining)
	cost = 40

/decl/hierarchy/supply_pack/munition/explosive
	name = "Ammo - disperser-XP4-INDARRA charge"
	contains = list(/obj/structure/ship_munition/disperser_charge/explosive)
	cost = 40