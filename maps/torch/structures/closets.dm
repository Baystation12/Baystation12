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

/obj/structure/closet/wardrobe/ptgear
	name = "pt gear wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/ptgear/New()
	..()
	new /obj/item/clothing/under/pt/expeditionary(src)
	new /obj/item/clothing/under/pt/expeditionary(src)
	new /obj/item/clothing/under/pt/expeditionary(src)
	new /obj/item/clothing/under/pt/expeditionary(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	return

obj/random/torchcloset //Random closets taking into account torch-specific ones
	name = "random closet"
	desc = "This is a random closet."
	icon = 'icons/obj/closet.dmi'
	icon_state = "syndicate1"
	item_to_spawn()
		return pick(/obj/structure/closet,\
					/obj/structure/closet/firecloset,\
					/obj/structure/closet/firecloset/full,\
					/obj/structure/closet/emcloset,\
					/obj/structure/closet/jcloset_torch,\
					/obj/structure/closet/athletic_mixed,\
					/obj/structure/closet/toolcloset,\
					/obj/structure/closet/toolcloset/excavation,\
					/obj/structure/closet/l3closet/general,\
					/obj/structure/closet/cabinet,\
					/obj/structure/closet/crate,\
					/obj/structure/closet/crate/freezer,\
					/obj/structure/closet/crate/freezer/rations,\
					/obj/structure/closet/crate/internals,\
					/obj/structure/closet/crate/trashcart,\
					/obj/structure/closet/crate/medical,\
					/obj/structure/closet/boxinggloves,\
					/obj/structure/closet/secure_closet/crew,\
					/obj/structure/closet/secure_closet/crew/research,\
					/obj/structure/closet/secure_closet/guncabinet,\
					/obj/structure/largecrate,\
					/obj/structure/closet/wardrobe/xenos,\
					/obj/structure/closet/wardrobe/mixed,\
					/obj/structure/closet/wardrobe/suit,\
					/obj/structure/closet/wardrobe/orange)