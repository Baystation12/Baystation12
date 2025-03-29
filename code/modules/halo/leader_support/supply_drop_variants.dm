#define PERSONALISED_AMMO_DROP_MAG_AMT 2
 //Halve mag-amount. Tracks subtypes of provided types.
#define PERSONALISED_AMMO_DROP_RESTRICT list(/obj/item/weapon/gun/projectile/na4_dp,/obj/item/weapon/gun/projectile/ACL55,/obj/item/weapon/gun/projectile/srs99_sniper,/obj/item/weapon/gun/projectile/m41,/obj/item/weapon/gun/projectile/fuel_rod,/obj/item/weapon/gun/projectile/boltshot,/obj/item/weapon/gun/projectile/suppressor)
//No. None. As above.
#define PERSONALISED_AMMO_DROP_EXCLUDE list(/obj/item/weapon/gun/projectile/binary_rifle)

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

//ammo supply drops

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
	/obj/item/ammo_magazine/m6d/m225,
	/obj/item/ammo_magazine/m6d/m225,
	/obj/item/ammo_magazine/m6d/m225,
	/obj/item/ammo_magazine/m6d/m225,
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
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	)

/datum/support_option/supply_drop/mass_ammo/odst
	name = "Supply Drop (ODST, Ammunition, Mass )"
	desc = "Contains a large cache of ammunition, retrieved from a nearby stealth support vessel.\n 4x a wide range of weapon magazines."
	rank_required = 3
	cooldown_inflict = 4 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop/mass_ammo/odst

/obj/structure/closet/crate/supply_drop/mass_ammo/odst
	name = "Supply Drop (ODST, Ammunition, Mass)"
	desc = "Used to drop supplies to groundside troops. Contains a large cache of ammunition."

obj/structure/closet/crate/supply_drop/mass_ammo/odst/WillContain()
	return list(\
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/ma5b/m118,
	/obj/item/ammo_magazine/m6s/m225,
	/obj/item/ammo_magazine/m6s/m225,
	/obj/item/ammo_magazine/m6s/m225,
	/obj/item/ammo_magazine/m6s/m225,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m392/m120,
	/obj/item/ammo_magazine/m7/m443/rnd48,
	/obj/item/ammo_magazine/m7/m443/rnd48,
	/obj/item/ammo_magazine/m7/m443/rnd48,
	/obj/item/ammo_magazine/m7/m443/rnd48,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_magazine/br55/m634,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	)

/datum/support_option/supply_drop/mass_ammo/urf
	name = "Supply Drop (URF, Ammunition, Mass )"
	desc = "Contains a large cache of ammunition, retrieved from a nearby stealth support vessel.\n 4x a wide range of weapon magazines."
	rank_required = 2
	cooldown_inflict = 4 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop/mass_ammo/urf

/obj/structure/closet/crate/supply_drop/mass_ammo/urf
	name = "Supply Drop (URF, Ammunition, Mass)"
	desc = "Used to drop supplies to groundside troops. Contains a large cache of ammunition."

/obj/structure/closet/crate/supply_drop/mass_ammo/urf/WillContain()
	return list(\
	/obj/item/ammo_magazine/ma37/m118,
	/obj/item/ammo_magazine/ma37/m118,
	/obj/item/ammo_magazine/ma37/m118,
	/obj/item/ammo_magazine/ma37/m118,
	/obj/item/ammo_magazine/m6d/m225,
	/obj/item/ammo_magazine/m6d/m225,
	/obj/item/ammo_magazine/m6d/m225,
	/obj/item/ammo_magazine/m6d/m225,
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
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
	/obj/item/ammo_box/shotgun,
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
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/spiker,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
	/obj/item/ammo_magazine/mauler,
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

/datum/support_option/supply_drop/personalised_ammo//re-enabled for power/specialist roles and up only.
	name = "Supply Drop (Ammunition, Personalised)"
	desc = "Contains a small cache of ammunition, retrieved from a nearby stealth support vessel.\n2 magazines of ammo for each unique weapon being carried."
	rank_required = 1
	cooldown_inflict = 4 MINUTES//I don't want these getting spammed
	item_to_drop = /obj/structure/closet/crate/supply_drop/personalised_ammo

/obj/structure/closet/crate/supply_drop/personalised_ammo
	name = "Supply Drop (Personal Ammunition)"
	desc = "Used to drop supplies to groundside troops. Contains a small supply of ammunition for a single person."

/datum/support_option/supply_drop/personalised_ammo/create_drop_item(var/turf/turf_at,var/mob/living/m)
	var/obj/structure/closet/c = ..()
	var/obj/item/weapon/paper/manifest = new (c)
	c.contents += manifest
	manifest.name = "Order Manifest"
	for(var/obj/item/weapon/gun/projectile/p in m.contents)
		var/drop_amt = PERSONALISED_AMMO_DROP_MAG_AMT
		for(var/type in PERSONALISED_AMMO_DROP_RESTRICT)
			if(istype(p,type))
				drop_amt = drop_amt/2
		for(var/type in PERSONALISED_AMMO_DROP_EXCLUDE)
			if(istype(p,type))
				drop_amt = 0
		if(drop_amt == 0)
			manifest.info += "[initial(p.name)] Ammunition x Not Available\n"
			continue
		manifest.info += "[initial(p.name)] Ammunition x [drop_amt]\n"
		var/item_drop = p.magazine_type
		if(isnull(item_drop))
			switch(p.caliber)
				if("shotgunhighpower")
					item_drop = /obj/item/ammo_box/shotgun
				if("railslug")
					drop_amt /= 2
					item_drop = /obj/item/ammo_box/railrifle
				if("14.5mmtracerless")
					item_drop = /obj/item/ammo_box/heavysniper
				else
					item_drop = null
		if(!isnull(item_drop))
			for(var/i = 1 to drop_amt)
				c.contents += new item_drop (c)
	return c


/datum/support_option/supply_drop/personalised_ammo_cov//above
	name = "Supply Drop (Covenant, Ammunition, Single )"
	desc = "Contains a small cache of ammunition, retrieved from a nearby stealth support vessel.\n2 magazines of ammo for each unique weapon being carried."
	arrival_sfx = 'code/modules/halo/sound/sprit_flyby.ogg'
	drop_delay = 2 SECONDS
	rank_required = 1
	cooldown_inflict = 4 MINUTES//I don't want these getting spammed
	item_to_drop = /obj/structure/closet/crate/supply_drop/cov/personalised

/obj/structure/closet/crate/supply_drop/cov/personalised
	name = "Supply Drop (Covenant, Ammunition, Single)"
	desc = "Used to drop supplies to groundside troops. Contains a small supply of ammunition for a single person."

/datum/support_option/supply_drop/personalised_ammo_cov/create_drop_item(var/turf/turf_at,var/mob/living/m)
	var/obj/structure/closet/c = ..()
	for(var/obj/item/weapon/gun/projectile/p in m.contents)
		for(var/i = 1 to PERSONALISED_AMMO_DROP_MAG_AMT)
			c.contents += new p.magazine_type (c)
	return c

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
	/obj/item/weapon/storage/pill_bottle/polypseudomorphine,
	/obj/item/weapon/reagent_containers/syringe/psychostimulant = 2,
	/obj/item/weapon/reagent_containers/syringe/synthblood = 2,
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
	/obj/item/weapon/storage/pill_bottle/covenant/polypseudomorphine,
	/obj/item/weapon/reagent_containers/syringe/psychostimulant = 2,
	/obj/item/weapon/reagent_containers/syringe/synthblood = 2,
	)

//RECON VEHICLE DROP//
/datum/support_option/supply_drop/vehicle_drop
	name = "Supply Drop (UNSC Recon Vehicle)"
	desc = "Contains a transport vehicle, retrieved from a nearby stealth support vessel."
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
	cooldown_inflict = 5 MINUTES
	item_to_drop = /obj/structure/closet/crate/supply_drop/construction

/obj/structure/closet/crate/supply_drop/construction
	name = "Type-B Supply Capsule (Construction)"
	desc = "Used to drop supplies to groundside troops. I am fortifying this position."

/obj/structure/closet/crate/supply_drop/construction/WillContain()
	return list(\
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/stack/material/plasteel/ten,
	/obj/item/weapon/storage/toolbox/mechanical,
	/obj/item/clothing/glasses/welding,
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
	/obj/item/stack/material/steel/fifty,
	/obj/item/stack/material/nanolaminate/ten,
	/obj/item/stack/material/nanolaminate/ten,
	/obj/item/stack/material/nanolaminate/ten,
	/obj/item/weapon/storage/toolbox/covenant_mech,
	/obj/item/clothing/glasses/welding,
	)