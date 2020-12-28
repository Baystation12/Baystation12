
//Currently disabled because it doesn't really fit with the idea of "SL is now an important person to keep alive"
/*
/datum/support_option/supply_drop/personalised_ammo
	name = "Supply Drop (Ammunition, Personalised)"
	desc = "Contains a small cache of ammunition, retrieved from a nearby stealth support vessel.\n2 magazines of ammo for each unique weapon being carried."
	rank_required = 0
	cooldown_inflict = 2.5 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop

/datum/support_option/supply_drop/personalised_ammo/create_drop_item(var/turf/turf_at,var/mob/living/m)
	var/obj/structure/closet/c = ..()
	for(var/obj/item/weapon/gun/projectile/p in m.contents)
		for(var/i = 1 to PERSONALISED_AMMO_DROP_MAG_AMT)
			c.contents += new p.magazine_type (c)
	return c
*/
/obj/structure/closet/crate/supply_drop
	name = "Type-B Supply Capsule"
	desc = "Used to drop supplies to groundside troops."
	icon = 'code/modules/halo/vehicles/supply_unsc.dmi'
	icon_state = "UNSC_Supply_closed"
	icon_closed = "UNSC_Supply_closed"
	icon_opened = "UNSC_Supply"

/obj/structure/closet/crate/supply_drop/cov
	name = "Covenant Resupply Capsule"
	icon = 'code/modules/halo/vehicles/supply_cov.dmi'
	icon_state = "Covenant_Supply_closed"
	icon_closed = "Covenant_Supply_closed"
	icon_opened = "Covenant_Supply"

/datum/support_option/supply_drop/mass_ammo
	name = "Supply Drop (UNSC, Ammunition, Mass )"
	desc = "Contains a large cache of ammunition, retrieved from a nearby stealth support vessel.\n 4x a wide range of weapon magazines."
	rank_required = 2
	cooldown_inflict = 4 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop/mass_ammo

/obj/structure/closet/crate/supply_drop/mass_ammo
	name = "Supply Drop (Ammunition, Mass)"
	desc = "Used to drop supplies to groundside troops. Contains a large cache of ammunition."

/obj/structure/closet/crate/supply_drop/mass_ammo/WillContain()
	return list(\
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/m6d/m224,
	/obj/item/ammo_magazine/m6d/m224,
	/obj/item/ammo_magazine/m6d/m224,
	/obj/item/ammo_magazine/m6d/m224,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m7/m443,
	/obj/item/ammo_magazine/m7/m443,
	/obj/item/ammo_magazine/m7/m443,
	/obj/item/ammo_magazine/m7/m443,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_magazine/br55/m634,
	)

/datum/support_option/supply_drop/mass_ammo/cov
	name = "Supply Drop (Covenant, Ammunition, Mass )"
	arrival_sfx = 'code/modules/halo/sound/sprit_flyby.ogg'
	drop_delay = 2 SECONDS
	item_to_drop = /obj/structure/closet/crate/supply_drop/cov/mass_ammo

/obj/structure/closet/crate/supply_drop/cov/mass_ammo
	name = "Supply Drop (Covenant, Ammunition, Mass)"
	desc = "Used to drop supplies to groundside troops. Contains a large cache of ammunition."

/obj/structure/closet/crate/supply_drop/cov/mass_ammo/WillContain()
	return list(\
	/obj/item/ammo_magazine/needles,
	/obj/item/ammo_magazine/needles,
	/obj/item/ammo_magazine/needles,
	/obj/item/ammo_magazine/needles,
	/obj/item/ammo_magazine/type51mag,
	/obj/item/ammo_magazine/type51mag,
	/obj/item/ammo_magazine/type51mag,
	/obj/item/ammo_magazine/type51mag,
	/obj/item/ammo_magazine/rifleneedlepack,
	/obj/item/ammo_magazine/rifleneedlepack,
	/obj/item/ammo_magazine/rifleneedlepack,
	/obj/item/ammo_magazine/rifleneedlepack,

	)

//Actual Supply Drops//
/datum/support_option/supply_drop/medical_drop
	name = "Supply Drop (UNSC Medical)"
	desc = "Contains a small cache of medical supplies, retrieved from a nearby stealth support vessel."
	rank_required = 2
	cooldown_inflict = 3.5 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop/medical

/obj/structure/closet/crate/supply_drop/medical
	name = "Type-B Supply Capsule (Medical)"
	desc = "Used to drop supplies to groundside troops. Contains various medical supplies."

/obj/structure/closet/crate/supply_drop/medical/WillContain()
	return list(\
	/obj/item/weapon/storage/firstaid/unsc,
	/obj/item/weapon/storage/firstaid/unsc,
	/obj/item/weapon/storage/firstaid/combat/unsc,
	/obj/item/weapon/storage/firstaid/combat/unsc,
	/obj/item/weapon/storage/pill_bottle/bicaridine,
	/obj/item/weapon/storage/pill_bottle/dermaline,
	/obj/item/weapon/storage/pill_bottle/polypseudomorphine
	)

/datum/support_option/supply_drop/medical_drop/cov
	name = "Supply Drop (Covenant Medical)"
	arrival_sfx = 'code/modules/halo/sound/sprit_flyby.ogg'
	drop_delay = 2 SECONDS
	item_to_drop = /obj/structure/closet/crate/supply_drop/cov/medical

/obj/structure/closet/crate/supply_drop/cov/medical
	name = "Supply Drop (Covenant, Medical)"
	desc = "Used to drop supplies to groundside troops. Contains various medical supplies."

/obj/structure/closet/crate/supply_drop/cov/medical/WillContain()
	return list(\
	/obj/item/weapon/storage/firstaid/unsc/cov,
	/obj/item/weapon/storage/firstaid/unsc/cov,
	/obj/item/weapon/storage/firstaid/combat/unsc/cov,
	/obj/item/weapon/storage/firstaid/combat/unsc/cov,
	/obj/item/weapon/storage/pill_bottle/covenant/bicaridine,
	/obj/item/weapon/storage/pill_bottle/covenant/dermaline,
	/obj/item/weapon/storage/pill_bottle/covenant/polypseudomorphine
	)

//RECON VEHICLE DROP//
/datum/support_option/supply_drop/vehicle_drop
	name = "Supply Drop (UNSC Recon Vehicle)"
	desc = "Contains a recon vehicle, retrieved from a nearby stealth support vessel."
	rank_required = 2
	cooldown_inflict = 5 MINUTES
	item_to_drop = /obj/vehicles/warthog/turretless/supplydrop_recon

/datum/support_option/supply_drop/vehicle_drop/cov
	name = "Supply Drop (Covenant Recon Vehicle)"
	arrival_sfx = 'code/modules/halo/sound/sprit_flyby.ogg'
	drop_delay = 2 SECONDS
	item_to_drop = /obj/vehicles/ghost/supplydrop_recon

/datum/support_option/supply_drop/vehicle_drop/cov/create_drop_item(var/turf/turf_at,var/mob/activator)
	. = ..()
	var/obj/dropped = new item_to_drop (turf_at)
	return dropped

//CONSTRUCTION DROP//
/datum/support_option/supply_drop/construction_drop
	name = "Supply Drop (UNSC Construction/Reinforcement)"
	desc = "Contains a variety of materials and some tools for construction and reinforcement of a position."
	rank_required = 2
	cooldown_inflict = 3 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop/construction

/obj/structure/closet/crate/supply_drop/construction
	name = "Type-B Supply Capsule (Construction)"
	desc = "Used to drop supplies to groundside troops. I am fortifying this position."

/obj/structure/closet/crate/supply_drop/construction/WillContain()
	return list(\
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/weapon/wrench,
	/obj/item/weapon/weldingtool,
	)

/datum/support_option/supply_drop/construction_drop/cov
	name = "Supply Drop (Covenant Construction/Reinforcement)"
	arrival_sfx = 'code/modules/halo/sound/sprit_flyby.ogg'
	drop_delay = 2 SECONDS
	item_to_drop = /obj/structure/closet/crate/supply_drop/cov/construction

/obj/structure/closet/crate/supply_drop/cov/construction
	name = "Covenant Resupply Capsule (Construction)"
	desc = "Used to drop supplies to groundside troops. I am fortifying this position."

/obj/structure/closet/crate/supply_drop/cov/construction/WillContain()
	return list(\
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/steel/ten,
	/obj/item/stack/material/nanolaminate/ten,
	/obj/item/stack/material/nanolaminate/ten,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/weapon/wrench,
	/obj/item/weapon/weldingtool,
	)