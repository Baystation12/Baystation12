
//A note for covenant weapon pricing: some weapons will be irregularly priced due to them
//falling outside of that species' usual weapon set//

/obj/machinery/vending/armory/covenant
	icon = 'code/modules/halo/covenant/structures_machines/covendor.dmi'
	icon_state ="covendor"
	icon_deny = "covendor-deny"

/obj/machinery/pointbased_vending/armory/covenant
	icon = 'code/modules/halo/covenant/structures_machines/covendor.dmi'
	icon_state ="covendor"
	icon_deny = "covendor-deny"

/obj/machinery/pointbased_vending/armory/covenant/allowed(var/mob/m) // Covenant lock
	var/mob/living/carbon/human/h = m
	if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	if(m & m.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	return 0

/obj/machinery/pointbased_vending/armory/covenant/sangheili/allowed(var/mob/living/carbon/human/h)
	if(istype(h,/mob/living/silicon))
		return 1
	if(!istype(h))
		return 0
	if(h.species.type == /datum/species/sangheili)
		return 1
	return 0

/obj/machinery/pointbased_vending/armory/covenant/jiralhanae/allowed(var/mob/living/carbon/human/h)
	if(istype(h,/mob/living/silicon))
		return 1
	if(!istype(h))
		return 0
	if(h.species.type == /datum/species/brutes)
		return 1
	return 0

/obj/machinery/pointbased_vending/armory/covenant/kigyar/allowed(var/mob/living/carbon/human/h)
	if(istype(h,/mob/living/silicon))
		return 1
	if(!istype(h))
		return 0
	if(h.species.type == /datum/species/kig_yar || h.species.type == /datum/species/kig_yar_skirmisher)
		return 1
	return 0

/obj/machinery/pointbased_vending/armory/covenant/unggoy/allowed(var/mob/living/carbon/human/h)
	if(istype(h,/mob/living/silicon))
		return 1
	if(!istype(h))
		return 0
	if(h.species.type == /datum/species/unggoy)
		return 1
	return 0

/obj/machinery/pointbased_vending/armory/covenant/yanmee/allowed(var/mob/living/carbon/human/h)
	if(istype(h,/mob/living/silicon))
		return 1
	if(!istype(h))
		return 0
	if(h.species.type == /datum/species/yanmee)
		return 1
	return 0

/obj/machinery/pointbased_vending/armory/covenant/sangheili/weapon // Both ammo, and guns!
	name = "Covenant - Sangheili Weapon Vendor"
	desc = "Storage for Covenant Sangheili weapons and ammo"
	products = list(
		"Melee" = -1,
		/obj/item/weapon/melee/energy/elite_sword/dagger = 0,
		"Guns" = -1,
		/obj/item/weapon/gun/energy/plasmapistol = 0,
		/obj/item/weapon/gun/projectile/needler = 0,
		/obj/item/weapon/gun/projectile/type31needlerifle = 0,
		/obj/item/weapon/gun/projectile/type51carbine = 0,
		/obj/item/weapon/gun/energy/plasmarifle = 0,
		/obj/item/weapon/gun/projectile/concussion_rifle = 0,
		/obj/item/weapon/gun/projectile/fuel_rod = 0,
		/obj/item/weapon/gun/energy/plasmarepeater = 0,
		/obj/item/weapon/gun/energy/beam_rifle = 0,
		"Ammunition" = -1,
		/obj/item/ammo_magazine/needles = 0,
		/obj/item/ammo_magazine/rifleneedlepack = 0,
		/obj/item/ammo_magazine/type51mag = 0,
		/obj/item/ammo_magazine/fuel_rod = 0,
		/obj/item/ammo_magazine/concussion_rifle = 0,
		"Explosives" = -1,
		/obj/item/weapon/grenade/plasma = 0,
		/obj/item/weapon/grenade/smokebomb/covenant = 0,
		"Misc" = -1,
		/obj/item/turret_deploy_kit/plasturret = 0
	)
	amounts = list(\
		/obj/item/weapon/gun/projectile/fuel_rod = 3,
		/obj/item/weapon/gun/energy/plasmarepeater = 3,
		/obj/item/weapon/gun/energy/beam_rifle = 3,
		/obj/item/weapon/grenade/plasma = 15,
		/obj/item/weapon/grenade/smokebomb/covenant = 15,
		/obj/item/turret_deploy_kit/plasturret = 4
	)

/obj/machinery/pointbased_vending/armory/covenant/sangheili/equipment // Equipment for Sangheili
	name = "Covenant - Sangheili Equipment Vendor"
	desc = "Storage for Covenant Sangheili equipment"
	products = list(
		"Storage" = -1,
		/obj/item/weapon/storage/belt/covenant_ammo = 2,
		/obj/item/weapon/storage/belt/covenant_medic = 1,
		/obj/item/weapon/storage/belt/utility/full = 0,
		/obj/item/clothing/accessory/storage/IFAK/cov = 1,
		/obj/item/clothing/accessory/storage/bandolier/covenant = 2,
		/obj/item/weapon/storage/backpack/sangheili = 3,
		"Storage - Holsters" = -1,
		/obj/item/clothing/accessory/holster = 1,
		/obj/item/clothing/accessory/holster/armpit = 1,
		/obj/item/clothing/accessory/holster/waist = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/clothing/accessory/holster/thigh = 1,
		"Storage - Hardcases" = -1,
		/obj/item/weapon/storage/pocketstore/hardcase/magazine/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/bullets/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov = 1,
		/obj/item/weapon/storage/pocketstore/hardcase/armorkits/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/medbottles/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/hypos/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/materials/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/tools/cov = 0,
		"EVA" = -1,
		/obj/item/weapon/storage/box/large/armorset/elite/eva = 0,
		/obj/item/weapon/tank/air/covenant = 0,
		/obj/item/clothing/mask/breath = 0,
		"Equipment" = -1,
		/obj/item/weapon/pickaxe/plasma_drill = 0,
		/obj/item/flight_item/covenant_pack = 0,
		/obj/item/dumb_ai_chip/cov = 0,
		/obj/item/weapon/plastique/covenant = 0,
		/obj/item/weapon/plastique/breaching/covenant = 0,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 0,
		/obj/item/weapon/armor_patch/cov = 0,
		/obj/item/weapon/armor_patch/mini/cov = 0,
		/obj/item/weapon/pinpointer/artifact = 0
	)
	amounts = list(\
		/obj/item/weapon/storage/box/large/armorset/elite/eva = 4,
		/obj/item/weapon/tank/air/covenant = 9,
		/obj/item/clothing/mask/breath = 7,
		/obj/item/weapon/pickaxe/plasma_drill = 1,
		/obj/item/flight_item/covenant_pack = 1,
		/obj/item/dumb_ai_chip/cov = 2,
		/obj/item/weapon/plastique/covenant = 8,
		/obj/item/weapon/plastique/breaching/covenant = 3,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 3,
		/obj/item/clothing/accessory/storage/IFAK/cov = 20,
		/obj/item/weapon/pinpointer/artifact = 3
	)

/obj/machinery/pointbased_vending/armory/covenant/jiralhanae/weapon // Both ammo, and guns!
	name = "Covenant - Jiralhanae Weapon Vendor"
	desc = "Storage for Covenant Jiralhanae weapons and ammo"
	products = list(
		"Melee" = -1,
		/obj/item/weapon/melee/energy/elite_sword/dagger = 0,
		/obj/item/weapon/grav_hammer/gravless = 0,
		"Guns" = -1,
		/obj/item/weapon/gun/energy/plasmapistol = 0,
		/obj/item/weapon/gun/projectile/mauler = 0,
		/obj/item/weapon/gun/projectile/spiker = 0,
		/obj/item/weapon/gun/energy/plasmarifle/brute = 0,
		/obj/item/weapon/gun/launcher/grenade/brute_shot = 0,
		"Ammunition" = -1,
		/obj/item/ammo_magazine/spiker = 0,
		/obj/item/ammo_magazine/mauler = 0,
		/obj/item/weapon/grenade/brute_shot = 0,
		"Explosives" = -1,
		/obj/item/weapon/grenade/smokebomb/covenant = 0,
		/obj/item/weapon/grenade/plasma = 0,
		/obj/item/weapon/grenade/frag/spike = 0,
	)
	amounts = list(
		/obj/item/weapon/gun/launcher/grenade/brute_shot = 3,
		/obj/item/weapon/grenade/smokebomb/covenant = 15,
		/obj/item/weapon/grenade/plasma = 15,
		/obj/item/weapon/grenade/frag/spike = 15,
	)

/obj/machinery/pointbased_vending/armory/covenant/jiralhanae/equipment // Equipment for Jiralhanae
	name = "Covenant - Jiralhanae Equipment Vendor"
	desc = "Storage for Covenant Jiralhanae weapons and ammo"
	products = list(
		"Storage" = -1,
		/obj/item/weapon/storage/belt/covenant_ammo = 2,
		/obj/item/weapon/storage/belt/covenant_medic = 1,
		/obj/item/weapon/storage/belt/utility/full = 0,
		/obj/item/clothing/accessory/storage/IFAK/cov = 1,
		/obj/item/clothing/accessory/storage/bandolier/covenant = 2,
		/obj/item/weapon/storage/backpack/sangheili = 3,
		"Storage - Holsters" = -1,
		/obj/item/clothing/accessory/holster = 1,
		/obj/item/clothing/accessory/holster/armpit = 1,
		/obj/item/clothing/accessory/holster/waist = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/clothing/accessory/holster/thigh = 1,
		"Storage - Hardcases" = -1,
		/obj/item/weapon/storage/pocketstore/hardcase/magazine/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/bullets/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov = 1,
		/obj/item/weapon/storage/pocketstore/hardcase/armorkits/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/medbottles/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/hypos/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/materials/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/tools/cov = 0,
		"EVA" = -1,
		/obj/item/weapon/storage/box/large/armorset/brute/eva = 0,
		/obj/item/weapon/tank/air/covenant = 0,
		"Equipment" = -1,
		/obj/item/flight_item/covenant_pack = 0,
		/obj/item/dumb_ai_chip/cov = 0,
		/obj/item/weapon/armor_patch/cov = 0,
		/obj/item/weapon/armor_patch/mini/cov = 0,
		/obj/item/weapon/pinpointer/artifact = 0,
	)
	amounts = list(\
		/obj/item/weapon/storage/box/large/armorset/brute/eva = 4,
		/obj/item/weapon/tank/air/covenant = 7,
		/obj/item/flight_item/covenant_pack = 2,
		/obj/item/dumb_ai_chip/cov = 2,
		/obj/item/clothing/accessory/storage/IFAK/cov = 20,
		/obj/item/weapon/pinpointer/artifact = 2,
	)

/obj/machinery/pointbased_vending/armory/covenant/kigyar/weapon // Both ammo, and guns!
	name = "Covenant - Kig-Yar Weapon Vendor"
	desc = "Storage for Covenant Kig-Yar weapons and ammo"
	products = list(
		"Melee" = -1,
		/obj/item/weapon/melee/blamite/cutlass = 0,
		/obj/item/weapon/melee/energy/elite_sword/dagger = 0,
		"Guns" = -1,
		/obj/item/weapon/gun/energy/plasmapistol = 0,
		/obj/item/weapon/gun/projectile/needler = 0,
		/obj/item/weapon/gun/projectile/type31needlerifle = 0,
		/obj/item/weapon/gun/projectile/type51carbine = 0,
		/obj/item/weapon/gun/energy/beam_rifle = 0,
		"Ammunition" = -1,
		/obj/item/ammo_magazine/needles = 0,
		/obj/item/ammo_magazine/rifleneedlepack = 0,
		/obj/item/ammo_magazine/type51mag = 0,
		"Explosives" = -1,
		/obj/item/weapon/gun/energy/beam_rifle = 0,
		/obj/item/weapon/grenade/plasma = 0,
		/obj/item/weapon/grenade/smokebomb/covenant = 0
	)
	amounts = list(\
		/obj/item/weapon/gun/energy/beam_rifle = 3,
		/obj/item/weapon/grenade/plasma = 15,
		/obj/item/weapon/grenade/smokebomb/covenant = 15
	)

/obj/machinery/pointbased_vending/armory/covenant/kigyar/equipment // Equipment for Kig-Yar
	name = "Covenant - Kig-Yar Equipment Vendor"
	desc = "Storage for Covenant Kig-Yar equipment"
	products = list(
		"Storage" = -1,
		/obj/item/weapon/storage/belt/covenant_ammo = 2,
		/obj/item/weapon/storage/belt/covenant_medic = 1,
		/obj/item/weapon/storage/belt/utility/full = 0,
		/obj/item/clothing/accessory/storage/IFAK/cov = 1,
		/obj/item/clothing/accessory/storage/bandolier/covenant = 2,
		/obj/item/weapon/storage/backpack/sangheili = 3,
		"Storage - Holsters" = -1,
		/obj/item/clothing/accessory/holster = 1,
		/obj/item/clothing/accessory/holster/armpit = 1,
		/obj/item/clothing/accessory/holster/waist = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/clothing/accessory/holster/thigh = 1,
		"Storage - Hardcases" = -1,
		/obj/item/weapon/storage/pocketstore/hardcase/magazine/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/bullets/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov = 1,
		/obj/item/weapon/storage/pocketstore/hardcase/armorkits/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/medbottles/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/hypos/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/materials/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/tools/cov = 0,
		"Equipment" = -1,
		/obj/item/flight_item/covenant_pack = 0,
		/obj/item/clothing/gloves/shield_gauntlet/kigyar = 0,
		/obj/item/clothing/under/kigyar/armless = 0,
		/obj/item/weapon/pickaxe/plasma_drill = 0,
		/obj/item/weapon/plastique/covenant = 0,
		/obj/item/weapon/plastique/breaching/covenant = 0,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 0,
		/obj/item/weapon/armor_patch/cov = 0,
		/obj/item/weapon/armor_patch/mini/cov = 0,
		/obj/item/weapon/pinpointer/artifact = 0
	)
	amounts = list(\
		/obj/item/flight_item/covenant_pack = 1,
		/obj/item/clothing/gloves/shield_gauntlet/kigyar = 6,
		/obj/item/clothing/under/kigyar/armless = 8,
		/obj/item/weapon/pickaxe/plasma_drill = 1,
		/obj/item/weapon/plastique/covenant = 6,
		/obj/item/weapon/plastique/breaching/covenant = 2,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 2,
		/obj/item/clothing/accessory/storage/IFAK/cov = 20,
		/obj/item/weapon/pinpointer/artifact = 2
	)

/obj/machinery/vending/armory/covenant/kigyar/ranger // Equipment for Kig-Yar
	name = "Covenant - Kig-Yar Ranger Vendor"
	desc = "Storage for Covenant Kig-Yar ranger equipment"
	products = list(
	/obj/item/weapon/storage/box/large/armorset/kigyar/eva = 4,
	/obj/item/weapon/tank/air/covenant = 8,
	/obj/item/clothing/mask/breath = 8
	)

/obj/machinery/pointbased_vending/armory/covenant/unggoy/weapon // Both ammo, and guns!
	name = "Covenant - Unggoy Weapon Vendor"
	desc = "Storage for Covenant Unggoy weapons and ammo"
	products = list(
		"Melee" = -1,
		/obj/item/weapon/melee/energy/elite_sword/dagger = 0,
		"Guns" = -1,
		/obj/item/weapon/gun/energy/plasmapistol = 0,
		/obj/item/weapon/gun/projectile/needler = 0,
		/obj/item/weapon/gun/energy/plasmarifle = 0,
		/obj/item/weapon/gun/projectile/fuel_rod = 0,
		/obj/item/weapon/gun/energy/plasmarepeater = 0,
		"Ammunition" = -1,
		/obj/item/ammo_magazine/needles = 0,
		/obj/item/ammo_magazine/fuel_rod = 0,
		"Explosives" = -1,
		/obj/item/weapon/grenade/plasma = 0,
		/obj/item/weapon/grenade/smokebomb/covenant = 0,
		"Misc" = -1,
		/obj/item/turret_deploy_kit/plasturret = 0
	)
	amounts = list(\
		/obj/item/weapon/gun/projectile/fuel_rod = 3,
		/obj/item/weapon/gun/energy/plasmarepeater = 3,
		/obj/item/weapon/grenade/plasma = 15,
		/obj/item/weapon/grenade/smokebomb/covenant = 12,
		/obj/item/turret_deploy_kit/plasturret = 4
	)

/obj/machinery/pointbased_vending/armory/covenant/unggoy/equipment // Equipment for Unggoy
	name = "Covenant - Unggoy Equipment Vendor"
	desc = "Storage for Covenant Unggoy equipment"
	products = list(
		"Storage" = -1,
		/obj/item/weapon/storage/belt/covenant_ammo = 2,
		/obj/item/weapon/storage/belt/covenant_medic = 1,
		/obj/item/weapon/storage/belt/utility/full = 0,
		/obj/item/clothing/accessory/storage/IFAK/cov = 1,
		/obj/item/clothing/accessory/storage/bandolier/covenant = 2,
		/obj/item/weapon/storage/backpack/sangheili = 3,
		"Storage - Holsters" = -1,
		/obj/item/clothing/accessory/holster = 1,
		/obj/item/clothing/accessory/holster/armpit = 1,
		/obj/item/clothing/accessory/holster/waist = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/clothing/accessory/holster/thigh = 1,
		"Storage - Hardcases" = -1,
		/obj/item/weapon/storage/pocketstore/hardcase/magazine/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/bullets/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov = 1,
		/obj/item/weapon/storage/pocketstore/hardcase/armorkits/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/medbottles/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/hypos/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/tools/cov = 0,
		"Equipment" = -1,
		/obj/item/weapon/pickaxe/plasma_drill = 0,
		/obj/item/weapon/plastique/covenant = 0,
		/obj/item/weapon/plastique/breaching/covenant = 0,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 0,
		/obj/item/weapon/armor_patch/cov = 0,
		/obj/item/weapon/armor_patch/mini/cov = 0,
		/obj/item/weapon/pinpointer/artifact = 0
	)
	amounts = list(\
		/obj/item/weapon/pickaxe/plasma_drill = 1,
		/obj/item/weapon/plastique/covenant = 6,
		/obj/item/weapon/plastique/breaching/covenant = 2,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 2,
		/obj/item/clothing/accessory/storage/IFAK/cov = 20,
		/obj/item/weapon/pinpointer/artifact = 1
	)

/obj/machinery/pointbased_vending/armory/covenant/yanmee/equipment
	name = "Covenant - Yanmee Equipment Vendor"
	desc = "Storage for Covenant Yanmee equipment"
	products = list(
		"Storage" = -1,
		/obj/item/weapon/storage/belt/covenant_ammo = 2,
		/obj/item/weapon/storage/belt/covenant_medic = 1,
		/obj/item/weapon/storage/belt/utility/full = 0,
		/obj/item/clothing/accessory/storage/IFAK/cov = 1,
		/obj/item/clothing/accessory/storage/bandolier/covenant = 2,
		/obj/item/weapon/storage/backpack/sangheili = 3,
		"Storage - Holsters" = -1,
		/obj/item/clothing/accessory/holster = 1,
		/obj/item/clothing/accessory/holster/armpit = 1,
		/obj/item/clothing/accessory/holster/waist = 1,
		/obj/item/clothing/accessory/holster/hip = 1,
		/obj/item/clothing/accessory/holster/thigh = 1,
		"Storage - Hardcases" = -1,
		/obj/item/weapon/storage/pocketstore/hardcase/magazine/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/bullets/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/grenade/cov = 1,
		/obj/item/weapon/storage/pocketstore/hardcase/armorkits/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/medbottles/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/hypos/cov = 0,
		/obj/item/weapon/storage/pocketstore/hardcase/materials/cov = 0,
		"Equipment" = -1,
		/obj/item/weapon/plastique/covenant = 0,
		/obj/item/weapon/plastique/breaching/covenant = 0,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 0,
		/obj/item/weapon/armor_patch/cov = 0,
		/obj/item/weapon/armor_patch/mini/cov = 0,
		/obj/item/weapon/pinpointer/artifact = 0
	)
	amounts = list(\
		/obj/item/weapon/plastique/covenant = 6,
		/obj/item/weapon/plastique/breaching/covenant = 2,
		/obj/item/weapon/plastique/breaching/longrange/covenant = 2,
		/obj/item/clothing/accessory/storage/IFAK/cov = 20,
		/obj/item/weapon/pinpointer/artifact = 1
	)

/obj/machinery/pointbased_vending/armory/covenant/yanmee/weapon
	name = "Covenant - Yanmee Weapon Vendor"
	desc = "Storage for Covenant Yanmee weapons and ammo"
	products = list(
		"Melee" = -1,
		/obj/item/weapon/melee/energy/elite_sword/dagger = 0,
		"Guns" = -1,
		/obj/item/weapon/gun/energy/plasmapistol = 0,
		/obj/item/weapon/gun/projectile/needler = 0,
		/obj/item/weapon/gun/energy/plasmarifle = 0,
		/obj/item/weapon/gun/projectile/type51carbine = 0,
		"Ammunition" = -1,
		/obj/item/ammo_magazine/needles = 0,
		/obj/item/ammo_magazine/type51mag = 0,
		"Explosives" = -1,
		/obj/item/weapon/grenade/smokebomb/covenant = 0,
		/obj/item/weapon/grenade/plasma = 0
	)
	amounts = list(\
		/obj/item/weapon/grenade/plasma = 15,
		/obj/item/weapon/grenade/smokebomb/covenant = 12
	)

/obj/machinery/vending/armory/covenant/sangheili/food
	name = "Covenant - Sangheili Food Vendor"
	desc = "A vendor for Sangheili oriented food."
	products = list(
	/obj/item/weapon/reagent_containers/food/snacks/covenant/colo = 20,
	/obj/item/weapon/reagent_containers/food/snacks/covenant/colo/stew = 15,
	/obj/item/weapon/reagent_containers/food/snacks/covenant/irukanbar = 25
	)

/obj/machinery/vending/armory/covenant/jiralhanae/food
	name = "Covenant - Jiralhanae Food Vendor"
	desc = "A vendor for Jiralhanae oriented food."
	products = list(
	/obj/item/weapon/reagent_containers/food/snacks/covenant/thornbeast = 20,
	/obj/item/weapon/reagent_containers/food/snacks/covenant/thornbeast/thorn = 15,
	/obj/item/weapon/reagent_containers/food/snacks/covenant/irukanbar = 25
	)

/obj/machinery/vending/armory/covenant/kigyar/food
	name = "Covenant - Kig-Yar Food Vendor"
	desc = "A vendor for Kig-Yar oriented food."
	products = list(
	/obj/item/weapon/reagent_containers/food/snacks/covenant/uoi = 20,
	/obj/item/weapon/reagent_containers/food/snacks/covenant/uoi/stew = 15,
	/obj/item/weapon/reagent_containers/food/snacks/covenant/irukanbar = 30
	)

/obj/machinery/vending/armory/covenant/general/food
	name = "Covenant - Lesser Food Vendor"
	desc = "A food vendor for the lesser species."
	products = list(
	/obj/item/weapon/reagent_containers/food/snacks/covenant/irukanbar = 35
	)

/obj/machinery/vending/armory/covenant/general/medical
	name = "Covenant - Medical Vendor"
	desc = "A vendor that supplies medical equipment"
	products = list(
	"Utility" = -1,
	/obj/item/bodybag/cryobag/covenant = 3,
	/obj/item/device/healthanalyzer/covenant = 10,
	"Medkits" = -1,
	/obj/item/weapon/storage/firstaid/unsc/cov = 10,
	/obj/item/weapon/storage/firstaid/fire/covenant = 2,
	/obj/item/weapon/storage/firstaid/o2/covenant = 4,
	/obj/item/weapon/storage/firstaid/toxin/covenant = 4,
	/obj/item/weapon/storage/firstaid/erk/cov = 4,
	/obj/item/weapon/storage/firstaid/combat/unsc/cov = 7,
	/obj/item/weapon/storage/firstaid/adv = 7,
	"Pill Bottles" = -1,
	/obj/item/weapon/storage/pill_bottle/covenant/bicaridine = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/dermaline = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/tramadol = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/polypseudomorphine = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/hyronalin = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/iron = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/dexalin_plus = 6,
	/obj/item/weapon/storage/pill_bottle/covenant/inaprovaline = 6,
	"Injectors" = -1,
	/obj/item/weapon/reagent_containers/hypospray = 3,
	/obj/item/weapon/reagent_containers/syringe/ld50_syringe/triadrenaline = 10,
	/obj/item/weapon/storage/box/syringes = 2,
		)

/obj/machinery/vending/armory/covenant/general/medical/surgery
	name = "Covenant - Surgery Vendor"
	desc = "A vendor that supplies surgery equipment."
	products = list(
	/obj/item/weapon/hemostat/covenant = 3,
	/obj/item/weapon/scalpel/covenant = 3,
	/obj/item/weapon/retractor/covenant = 3,
	/obj/item/weapon/cautery/covenant = 3,
	/obj/item/weapon/circular_saw/covenant = 3,
	/obj/item/weapon/surgicaldrill/covenant = 3,
	/obj/item/weapon/bonesetter/covenant = 3,
	/obj/item/weapon/FixOVein = 3,
	/obj/item/stack/nanopaste = 3,
	/obj/item/weapon/bonegel = 3,
	/obj/item/stack/medical/advanced/bruise_pack = 3,
	/obj/item/weapon/storage/box/gloves = 3,
	/obj/item/weapon/tank/anesthetic = 3,
	/obj/item/weapon/reagent_containers/blood/OMinus = 6,
	/obj/item/weapon/reagent_containers/blood/empty = 12,
	/obj/item/weapon/reagent_containers/spray/cleaner = 2
	)
