var/global/list/datum/supply_drop_loot/supply_drop

/proc/supply_drop_random_loot_types()
	if(!supply_drop)
		supply_drop = init_subtypes(/datum/supply_drop_loot)
		supply_drop = dd_sortedObjectList(supply_drop)
	return supply_drop

/datum/supply_drop_loot
	var/name = ""
	var/container = null
	var/list/contents = null

/datum/supply_drop_loot/proc/contents()
	return contents

/datum/supply_drop_loot/proc/drop(turf/T)
	var/C = container ? new container(T) : T
	for(var/content in contents())
		new content(C)

/datum/supply_drop_loot/dd_SortValue()
	return name

/datum/supply_drop_loot/supermatter
	name = "Supermatter"
/datum/supply_drop_loot/supermatter/New()
	..()
	contents = list(/obj/machinery/power/supermatter)

/datum/supply_drop_loot/lasers
	name = "Lasers"
	container = /obj/structure/largecrate
/datum/supply_drop_loot/lasers/New()
	..()
	contents = list(
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/sniperrifle,
		/obj/item/weapon/gun/energy/ionrifle)

/datum/supply_drop_loot/ballistics
	name = "Ballistics"
	container = /obj/structure/largecrate
/datum/supply_drop_loot/ballistics/New()
	..()
	contents = list(
		/obj/item/weapon/gun/projectile/sec,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/automatic/wt550,
		/obj/item/weapon/gun/projectile/automatic/z8)

/datum/supply_drop_loot/ballistics
	name = "Ballistics"
	container = /obj/structure/largecrate
/datum/supply_drop_loot/ballistics/New()
	..()
	contents = list(
		/obj/item/weapon/gun/projectile/sec,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/automatic/wt550,
		/obj/item/weapon/gun/projectile/automatic/z8)

/datum/supply_drop_loot/armour
	name = "Armour"
	container = /obj/structure/largecrate
/datum/supply_drop_loot/armour/New()
	..()
	contents = list(
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/armor/vest,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/suit/armor/bulletproof)

/datum/supply_drop_loot/medical
	name = "Medical"
	container = /obj/structure/closet/crate/medical
/datum/supply_drop_loot/medical/New()
	..()
	contents = list(
		/obj/item/weapon/storage/firstaid/regular,
		/obj/item/weapon/storage/firstaid/fire,
		/obj/item/weapon/storage/firstaid/toxin,
		/obj/item/weapon/storage/firstaid/o2,
		/obj/item/weapon/storage/firstaid/adv,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/storage/box/autoinjectors)

