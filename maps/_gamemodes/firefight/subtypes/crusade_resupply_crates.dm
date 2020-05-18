
/obj/structure/closet/crate/random/covenant
	name = "Covenant resupply capsule"
	icon = 'code/modules/halo/vehicles/supply_cov.dmi'
	icon_state = "Covenant_Supply_closed"
	icon_closed = "Covenant_Supply_closed"
	icon_opened = "Covenant_Supply"

/obj/structure/closet/crate/random/covenant/weapons
	name = "Weapons supply capsule"
	num_contents = 2
	possible_spawns = list(\
		/obj/item/weapon/gun/energy/plasmarifle,\
		/obj/item/weapon/gun/energy/plasmarepeater)

/obj/structure/closet/crate/random/covenant/weapons/WillContain()
	var/list/contains = list(\
		/obj/item/weapon/grenade/plasma,\
		/obj/item/weapon/grenade/plasma,\
		/obj/item/weapon/armor_patch/cov)

	if(prob(50))
		contains += /obj/item/clothing/gloves/shield_gauntlet

	if(prob(50))
		contains += /obj/item/weapon/storage/belt/covenant_ammo
	else
		contains += /obj/item/clothing/accessory/storage/bandolier/covenant

	if(prob(50))
		contains += /obj/item/weapon/gun/projectile/needler
		contains += /obj/item/ammo_magazine/needles
		contains += /obj/item/ammo_magazine/needles
	else
		contains += /obj/item/weapon/gun/energy/plasmapistol

	contains += pick(\
		/obj/item/weapon/melee/baton/humbler/covenant,\
		/obj/item/weapon/melee/energy/elite_sword/dagger,\
		/obj/item/weapon/melee/blamite/dagger,\
		/obj/item/weapon/melee/blamite/cutlass)

	return contains

/obj/structure/closet/crate/random/covenant/marksman
	name = "Marksman supply capsule"
	num_contents = 2
	possible_spawns = list(\
		/obj/item/weapon/gun/energy/beam_rifle,\
		/obj/item/weapon/gun/projectile/type51carbine = /obj/item/ammo_magazine/type51mag,\
		/obj/item/weapon/gun/projectile/type31needlerifle = /obj/item/ammo_magazine/rifleneedlepack)

/obj/structure/closet/crate/random/covenant/weapons_brute
	name = "Jiralhanae supply capsule"
	num_contents = 2
	possible_spawns = list(\
		/obj/item/weapon/gun/energy/plasmarifle/brute,\
		/obj/item/weapon/gun/launcher/grenade/brute_shot = /obj/item/weapon/grenade/brute_shot)

/obj/structure/closet/crate/random/covenant/weapons_brute/WillContain()
	var/list/contains = list(/obj/item/weapon/armor_patch/cov)

	contains += pick(/obj/item/weapon/grenade/toxic_gas, /obj/item/weapon/grenade/frag/spike)
	contains += pick(/obj/item/weapon/grenade/toxic_gas, /obj/item/weapon/grenade/frag/spike)

	if(prob(50))
		contains += /obj/item/weapon/gun/projectile/spiker
		contains += /obj/item/ammo_magazine/spiker
		contains += /obj/item/ammo_magazine/spiker
	else
		contains += /obj/item/weapon/gun/projectile/mauler
		contains += /obj/item/ammo_magazine/mauler
		contains += /obj/item/ammo_magazine/mauler

	return contains

/obj/structure/closet/crate/random/covenant/fuel_rod
	name = "Fuel rod supply capsule"

/obj/structure/closet/crate/random/covenant/fuel_rod/WillContain()
	return list(/obj/item/weapon/gun/projectile/fuel_rod)

/obj/structure/closet/crate/random/covenant/energy_barricades
	name = "Energy barricades supply capsule"

/obj/structure/closet/crate/random/covenant/energy_barricades/WillContain()
	return list(\
		/obj/item/energybarricade,\
		/obj/item/energybarricade,\
		/obj/item/energybarricade,\
		/obj/item/energybarricade)

/obj/structure/closet/crate/random/covenant/food
	name = "Food supply capsule"
	num_contents = 6
	possible_spawns = list(\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/irukanbar,\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/colo,\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/colo/stew,\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/uoi,\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/uoi/stew,\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/thornbeast/thorn,\
		/obj/item/weapon/reagent_containers/food/snacks/covenant/thornbeast)

/obj/structure/closet/crate/random/covenant/construction
	name = "Construction supply capsule"
	num_contents = 4
	possible_spawns = list(\
		/obj/item/device/flashlight/glowstick/covenant,\
		/obj/item/weapon/cell/covenant,\
		/obj/item/clothing/head/welding/covenant,\
		/obj/item/device/flashlight/covenant,\
		/obj/item/stack/material/nanolaminate/fifty)

/obj/structure/closet/crate/random/covenant/construction/WillContain()
	return list(\
		/obj/item/weapon/storage/belt/covenant/full,\
		/obj/item/stack/material/nanolaminate/fifty)

/obj/structure/closet/crate/random/covenant/medical
	name = "Medical supply capsule"
	num_contents = 2
	no_doubleups = 1
	possible_spawns = list(\
		/obj/item/weapon/storage/firstaid/surgery/covenant,\
		/obj/item/weapon/storage/firstaid/fire/covenant,\
		/obj/item/weapon/storage/firstaid/toxin/covenant,\
		/obj/item/weapon/storage/firstaid/combat/covenant)

/obj/structure/closet/crate/random/covenant/medical/WillContain()
	return list(\
		/obj/item/weapon/storage/firstaid/unsc/cov,\
		/obj/item/weapon/storage/firstaid/combat/unsc/cov,\
		/obj/item/weapon/storage/belt/covenant_medic)
