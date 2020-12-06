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
	name = "Ammo - BSA-FR1-ENFER charge"
	contains = list(/obj/structure/ship_munition/bsa_charge/fire)
	cost = 40

/decl/hierarchy/supply_pack/munition/emp
	name = "Ammo - BSA-EM2-QUASAR charge"
	contains = list(/obj/structure/ship_munition/bsa_charge/emp)
	cost = 40

/decl/hierarchy/supply_pack/munition/mining
	name = "Ammo - BSA-MN3-BERGBAU charge"
	contains = list(/obj/structure/ship_munition/bsa_charge/mining)
	cost = 40

/decl/hierarchy/supply_pack/munition/explosive
	name = "Ammo - BSA-XP4-INDARRA charge"
	contains = list(/obj/structure/ship_munition/bsa_charge/explosive)
	cost = 40