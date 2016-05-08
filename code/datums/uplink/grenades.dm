/***********
* Grenades *
************/
/datum/uplink_item/item/grenades
	category = /datum/uplink_category/grenades

/datum/uplink_item/item/grenades/anti_photon
	name = "5xPhoton Disruption Grenades"
	item_cost = 4
	path = /obj/item/weapon/storage/box/anti_photons

/datum/uplink_item/item/grenades/smoke
	name = "5xSmoke Grenades"
	item_cost = 4
	path = /obj/item/weapon/storage/box/smokes

/datum/uplink_item/item/grenades/emp
	name = "5xEMP Grenades"
	item_cost = 6
	path = /obj/item/weapon/storage/box/emps

/datum/uplink_item/item/grenades/frag_high_yield
	name = "Fragmentation Bomb"
	item_cost = 6
	antag_roles = list(MODE_MERCENARY) // yeah maybe regular traitors shouldn't be able to get these
	path = /obj/item/weapon/grenade/frag/high_yield

/datum/uplink_item/item/grenades/fragshell
	name = "5xFragmentation Shells"
	desc = "Weaker than standard fragmentation grenades, these devices can be fired from a grenade launcher."
	item_cost = 10
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/storage/box/fragshells

/datum/uplink_item/item/grenades/frag
	name = "5xFragmentation Grenades"
	item_cost = 10
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/storage/box/frags
