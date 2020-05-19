
/obj/structure/closet/crate/random
	desc = "Type-B Supply Capsule. Used to drop supplies to groundside troops."
	icon = 'code/modules/halo/vehicles/supply_unsc.dmi'
	icon_state = "UNSC_Supply_closed"
	icon_closed = "UNSC_Supply_closed"
	icon_opened = "UNSC_Supply"
	var/list/possible_spawns = list()
	var/num_contents = 3
	var/no_doubleups = 0

/obj/structure/closet/crate/random/Initialize()
	. = ..()

	for(var/i=0,i<num_contents,i++)
		if(!possible_spawns.len)
			break
		var/spawn_type = pick(possible_spawns)
		new spawn_type(src)

		//does this have ammo as well?
		var/second_type = possible_spawns[spawn_type]
		if(second_type)
			new second_type(src)
			new second_type(src)

		//can we spawn this one multiple times?
		if(no_doubleups)
			possible_spawns -= spawn_type

/obj/structure/closet/crate/random/unsc_guns
	name = "Weapons Capsule"
	possible_spawns = list(\
		/obj/item/weapon/gun/projectile/ma5b_ar = /obj/item/ammo_magazine/m762_ap,\
		/obj/item/weapon/gun/projectile/m7_smg = /obj/item/ammo_magazine/m5,\
		/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = /obj/item/weapon/storage/box/shotgunshells)

/obj/structure/closet/crate/random/unsc_guns/WillContain()
	return list(/obj/item/weapon/gun/projectile/m6d_magnum,\
		/obj/item/ammo_magazine/m127_saphe,\
		/obj/item/ammo_magazine/m127_saphe)

/obj/structure/closet/crate/random/unsc_advguns
	name = "Advanced Weapons Capsule"
	num_contents = 2
	possible_spawns = list(
		/obj/item/weapon/gun/projectile/br85 = /obj/item/ammo_magazine/m95_sap,\
		/obj/item/weapon/gun/projectile/m392_dmr = /obj/item/ammo_magazine/m762_ap,\
		/obj/item/weapon/gun/projectile/m739_lmg = /obj/item/ammo_magazine/a762_box_ap)

/obj/structure/closet/crate/random/unsc_missile
	name = "SPNKr Capsule"

/obj/structure/closet/crate/random/unsc_missile/WillContain()
	return list(/obj/item/weapon/gun/projectile/m41,\
		/obj/item/ammo_magazine/spnkr,\
		/obj/item/ammo_magazine/spnkr)

/obj/structure/closet/crate/random/unsc_splaser
	name = "M6 Nonlinear Rifle Capsule"

/obj/structure/closet/crate/random/unsc_splaser/WillContain()
	return list(/obj/item/weapon/gun/energy/charged/spartanlaser)

/obj/structure/closet/crate/random/unsc_sniper
	name = "Marksman Capsule"
	num_contents = 1
	possible_spawns = list(/obj/item/weapon/gun/projectile/srs99_sniper = /obj/item/ammo_magazine/m145_ap)

/obj/structure/closet/crate/random/unsc_landmine
	name = "Landmines Capsule"
	num_contents = 6
	possible_spawns = list(\
		/obj/item/device/landmine/explosive,\
		/obj/item/device/landmine/frag)

/obj/structure/closet/crate/random/unsc_armour
	name = "Armour Capsule"

/obj/structure/closet/crate/random/unsc_armour/Initialize()

	if(prob(50))
		new /obj/item/clothing/head/helmet/marine(src)
	else
		new /obj/item/clothing/head/helmet/marine/visor(src)

	new /obj/item/clothing/suit/storage/marine(src)

	if(prob(50))
		var/obj/item/weapon/storage/belt/B = new /obj/item/weapon/storage/belt/marine_ammo(src)
		new /obj/item/weapon/gun/projectile/m6d_magnum(B)
		new /obj/item/ammo_magazine/m127_saphe(B)
		new /obj/item/ammo_magazine/m127_saphe(B)
	else
		var/obj/item/weapon/storage/belt/B = new /obj/item/weapon/storage/belt/marine_medic(src)
		new /obj/item/weapon/storage/firstaid/unsc(B)

	new /obj/item/weapon/armor_patch(src)
	new /obj/item/weapon/armor_patch(src)
	new /obj/item/weapon/armor_patch(src)
	new /obj/item/weapon/armor_patch(src)

	. = ..()

/obj/structure/closet/crate/random/unsc_turret
	name = "Turret Capsule"
	num_contents = 1
	possible_spawns = list(/obj/item/turret_deploy_kit/HMG,\
	/obj/item/turret_deploy_kit/chaingun)

/obj/structure/closet/crate/random/unsc_medic
	name = "Medical Capsule"
	num_contents = 3
	no_doubleups = 1
	possible_spawns =  list(\
		/obj/item/weapon/storage/firstaid/fire,\
		/obj/item/weapon/storage/firstaid/toxin,\
		/obj/item/weapon/storage/firstaid/adv,\
		/obj/item/weapon/storage/firstaid/surgery)

/obj/structure/closet/crate/random/unsc_medic/WillContain()
	return list(/obj/item/weapon/storage/firstaid/unsc,\
		/obj/item/weapon/storage/firstaid/combat/unsc,\
		/obj/item/weapon/storage/belt/marine_medic)

/obj/structure/closet/crate/random/unsc_misc
	name = "Misc Capsule"
	num_contents = 4
	possible_spawns =  list(\
		/obj/item/weapon/material/knife/combat_knife,\
		/obj/item/weapon/material/machete,\
		/obj/item/device/flashlight/flare,\
		/obj/item/device/flashlight,\
		/obj/item/weapon/cell/high,\
		/obj/item/weapon/melee/baton/humbler)

/obj/structure/closet/crate/random/unsc_misc/WillContain()
	return list(\
		/obj/item/weapon/storage/box/m9_frag,\
		/obj/item/weapon/armor_patch,\
		/obj/item/weapon/armor_patch,\
		/obj/item/weapon/armor_patch)

/obj/structure/closet/crate/random/unsc_tools
	name = "Tools Capsule"
	num_contents = 4
	possible_spawns =  list(\
		/obj/item/weapon/storage/toolbox/mechanical,\
		/obj/item/weapon/material/hatchet,\
		/obj/item/weapon/shovel,\
		/obj/item/weapon/cell/high,\
		/obj/item/weapon/storage/belt/utility/full)

/obj/structure/closet/crate/random/unsc_tools/WillContain()
	return list(/obj/item/weapon/storage/toolbox/mechanical,\
		/obj/item/weapon/storage/belt/utility/full)

/obj/item/stack/material/cloth/fifty
	amount = 50

/obj/structure/closet/crate/random/unsc_mats
	name = "Construction Materials Capsule"
	num_contents = 4
	possible_spawns =  list(\
		/obj/item/stack/material/cloth/fifty,\
		/obj/item/stack/material/wood/fifty,\
		/obj/item/stack/material/plasteel/fifty,\
		/obj/item/stack/material/steel/fifty)

/obj/structure/closet/crate/random/unsc_mats/WillContain()
	return list(/obj/item/stack/material/plasteel/fifty,\
		/obj/item/stack/material/steel/fifty)

/obj/structure/closet/crate/random/unsc_food
	name = "Food Capsule"
	num_contents = 6
	possible_spawns =  list(\
		/obj/item/weapon/storage/box/MRE/Chicken,\
		/obj/item/weapon/storage/box/MRE/Pizza,\
		/obj/item/weapon/storage/box/MRE/Spaghetti
	)
