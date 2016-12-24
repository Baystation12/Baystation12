/*
 * Torch Excavation
 */

/obj/structure/closet/toolcloset/excavation
	name = "excavation equipment closet"
	desc = "It's a storage unit for excavation equipment."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/toolcloset/excavation/New()
		..()
		new /obj/item/weapon/storage/belt/archaeology(src)
		new /obj/item/weapon/storage/excavation(src)
		new /obj/item/device/flashlight/lantern(src)
		new /obj/item/device/ano_scanner(src)
		new /obj/item/device/depth_scanner(src)
		new /obj/item/device/core_sampler(src)
		new /obj/item/device/gps(src)
		new /obj/item/device/beacon_locator(src)
		new /obj/item/device/radio/beacon(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/clothing/glasses/science(src)
		new /obj/item/weapon/pickaxe(src)
		new /obj/item/device/measuring_tape(src)
		new /obj/item/weapon/pickaxe/hand(src)
		new /obj/item/weapon/storage/bag/fossils(src)
		new /obj/item/weapon/hand_labeler(src)
		new /obj/item/taperoll/research(src)
