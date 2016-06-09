/*
 * The 'fancy' path is for objects like candle boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 *
 * Contains:
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy
	item_state = "syringe_kit" //placeholder, many of these don't have inhands
	var/obj/item/key_type //path of the key item that this "fancy" container is meant to store
	var/opened = 0 //if an item has been removed from this container

/obj/item/weapon/storage/fancy/remove_from_storage()
	. = ..()
	if(!opened && .)
		opened = 1
		update_icon()


/obj/item/weapon/storage/fancy/update_icon()
	if(!opened)
		src.icon_state = initial(icon_state)
	else
		var/key_count = count_by_type(contents, key_type)
		src.icon_state = "[initial(icon_state)][key_count]"

/obj/item/weapon/storage/fancy/examine(mob/user)
	if(!..(user, 1))
		return

	var/key_name = initial(key_type.name)
	if(!contents.len)
		user << "There are no [key_name]s left in the box."
	else
		var/key_count = count_by_type(contents, key_type)
		user << "There [key_count == 1? "is" : "are"] [key_count] [key_name]\s in the box."

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	name = "egg box"
	storage_slots = 12
	max_w_class = 2
	w_class = 3

	key_type = /obj/item/weapon/reagent_containers/food/snacks/egg
	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
		)

	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/egg = 12)


/*
 * Candle Box
 */

/obj/item/weapon/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox"
	opened = 1 //no closed state
	throwforce = 2
	w_class = 2
	max_w_class = 1
	max_storage_space = 5
	slot_flags = SLOT_BELT

	key_type = /obj/item/weapon/flame/candle
	startswith = list(/obj/item/weapon/flame/candle = 5)

/*
 * Crayon Box
 */

/obj/item/weapon/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2
	max_w_class = 1
	max_storage_space = 6

	key_type = /obj/item/weapon/pen/crayon
	startswith = list(
		/obj/item/weapon/pen/crayon/red,
		/obj/item/weapon/pen/crayon/orange,
		/obj/item/weapon/pen/crayon/yellow,
		/obj/item/weapon/pen/crayon/green,
		/obj/item/weapon/pen/crayon/blue,
		/obj/item/weapon/pen/crayon/purple,
		)

/obj/item/weapon/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/crayons.dmi',"crayonbox")
	for(var/obj/item/weapon/pen/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

////////////
//CIG PACK//
////////////
/obj/item/weapon/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 2
	max_w_class = 1
	max_storage_space = 6
	startswith = 6
	throwforce = 2
	slot_flags = SLOT_BELT

	key_type = /obj/item/clothing/mask/smokable/cigarette
	startswith = list(/obj/item/clothing/mask/smokable/cigarette = 6)

/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	flags |= NOREACT
	create_reagents(5 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	flags |= OPENCONTAINER

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == "mouth")
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = null
		for(var/obj/item/clothing/mask/smokable/cigarette/C in contents)
			cig = C
			break

		if(cig == null)
			user << "<span class='notice'>Looks like the packet is out of cigarettes.</span>"
			return

		// Instead of running equip_to_slot_if_possible() we check here first,
		// to avoid dousing cig with reagents if we're not going to equip it
		if(!cig.mob_can_equip(user, slot_wear_mask))
			return

		// We call remove_from_storage first to manage the reagent transfer and
		// UI updates.
		remove_from_storage(cig, null)
		user.equip_to_slot(cig, slot_wear_mask)

		reagents.maximum_volume = 5 * contents.len
		user << "<span class='notice'>You take a cigarette out of the pack.</span>"
		update_icon()
	else
		..()

/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\"."
	icon_state = "Dpacket"

/obj/item/weapon/storage/fancy/cigarettes/killthroat
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"

/obj/item/weapon/storage/fancy/cigarettes/killthroat/New()
	..()
	fill_cigarre_package(src,list("fuel" = 4))

/obj/item/weapon/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigpacket"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = 2
	max_w_class = 1
	max_storage_space = 6
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7

	key_type = /obj/item/clothing/mask/smokable/cigarette/cigar
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/cigar = 6)

/obj/item/weapon/storage/fancy/cigar/New()
	..()
	flags |= NOREACT
	create_reagents(10 * storage_slots)

/obj/item/weapon/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
	if(!istype(C)) return
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/*
 * Vial Box
 */

/obj/item/weapon/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox"
	name = "vial storage box"
	w_class = 3
	max_w_class = 1
	storage_slots = 12

	key_type = /obj/item/weapon/reagent_containers/glass/beaker/vial
	startswith = list(/obj/item/weapon/reagent_containers/glass/beaker/vial = 12)

/obj/item/weapon/storage/fancy/vials/update_icon()
	var/key_count = count_by_type(contents, key_type)
	src.icon_state = "[initial(icon_state)][Floor(key_count/2)]"

/*
 * Not actually a "fancy" storage...
 */
/obj/item/weapon/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 1
	max_storage_space = null
	storage_slots = 12
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/update_icon()
	var/total_contents = count_by_type(contents, /obj/item/weapon/reagent_containers/glass/beaker/vial)
	src.icon_state = "vialbox[Floor(total_contents/2)]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/vials/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	update_icon()
