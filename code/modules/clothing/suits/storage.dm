/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets/pockets
	var/slots = 2

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal/pockets(src, slots, ITEM_SIZE_SMALL) //fit only pocket sized items

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	. = ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user as mob)
	if (pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object as obj)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)


/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/storage/vest/merc
	slots = 4

/obj/item/clothing/suit/storage/vest/tactical
	slots = 4
