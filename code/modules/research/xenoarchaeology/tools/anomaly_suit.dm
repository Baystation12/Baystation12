//changes: rad protection up to 100 from 20/50 respectively
/obj/item/clothing/suit/bio_suit/anomaly
	name = "Anomaly suit"
	desc = "A suit that protects against exotic alien energies and biological contamination."
	icon_state = "bio_anom"
	item_state = "bio_anom"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)

/obj/item/clothing/head/bio_hood/anomaly
	name = "Anomaly hood"
	desc = "A hood that protects the head and face from exotic alien energies and biological contamination."
	icon_state = "bio_anom"
	item_state = "bio_anom"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)

/obj/item/clothing/suit/space/void/excavation
	name = "excavation voidsuit"
	desc = "A specially shielded voidsuit that insulates against some exotic alien energies, as well as the more mundane dangers of excavation."
	icon_state = "rig-excavation"
	armor = list(melee = 30, bullet = 0, laser = 5,energy = 40, bomb = 35, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils)

/obj/item/clothing/head/helmet/space/void/excavation
	name = "excavation voidsuit helmet"
	desc = "A sophisticated voidsuit helmet, capable of protecting the wearer from many exotic alien energies."
	icon_state = "rig0-excavation"
	item_state = "excavation-helm"
	armor = list(melee = 30, bullet = 0, laser = 5,energy = 40, bomb = 35, bio = 100, rad = 100)
	light_overlay = "hardhat_light"
