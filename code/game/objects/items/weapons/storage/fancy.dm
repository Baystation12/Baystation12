/*
 * The 'fancy' path is for objects like candle boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 *
 * Contains:
 *		Egg Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy
	item_state = "syringe_kit" //placeholder, many of these don't have inhands
	opened = 0 //if an item has been removed from this container
	var/obj/item/key_type //path of the key item that this "fancy" container is meant to store

/obj/item/weapon/storage/fancy/on_update_icon()
	if(!opened)
		src.icon_state = initial(icon_state)
	else
		var/key_count = count_by_type(contents, key_type)
		src.icon_state = "[initial(icon_state)][key_count]"

/obj/item/weapon/storage/fancy/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return

	var/key_name = initial(key_type.name)
	if(!contents.len)
		to_chat(user, "There are no [key_name]s left in the box.")
	else
		var/key_count = count_by_type(contents, key_type)
		to_chat(user, "There [key_count == 1? "is" : "are"] [key_count] [key_name]\s in the box.")

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	name = "egg box"
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL

	key_type = /obj/item/weapon/reagent_containers/food/snacks/egg
	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
		)

	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/egg = 12)

/obj/item/weapon/storage/fancy/egg_box/empty
	startswith = null

/*
 * Cracker Packet
 */

/obj/item/weapon/storage/fancy/crackers
	name = "\improper Getmore Crackers"
	icon = 'icons/obj/food.dmi'
	icon_state = "crackerbag"
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	w_class = ITEM_SIZE_SMALL
	key_type = /obj/item/weapon/reagent_containers/food/snacks/cracker
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/cracker)
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/cracker = 6)

/*
 * Crayon Box
 */

/obj/item/weapon/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
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

/obj/item/weapon/storage/fancy/crayons/on_update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/crayons.dmi',"crayonbox")
	for(var/obj/item/weapon/pen/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

/*
 * Pencil Case
 */

/obj/item/weapon/storage/fancy/pencilcase
	name = "pencil case"
	desc = "A pencil case for all those schoolboys to carry."
	icon = 'icons/obj/storage.dmi'
	icon_state = "pencil_case"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6 * ITEM_SIZE_TINY
	key_type = /obj/item/weapon/pen
	startswith = list(
		/obj/item/weapon/pen,
		/obj/item/weapon/pen/blue,
		/obj/item/weapon/pen/red,
		/obj/item/weapon/pen/green,
		/obj/item/weapon/pen/crayon/yellow,
		/obj/item/weapon/pen/crayon/purple,
		)

////////////
//CIG PACK//
////////////
/obj/item/weapon/storage/fancy/cigarettes
	name = "pack of Trans-Stellar Duty-frees"
	desc = "A ubiquitous brand of cigarettes, found in the facilities of every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	throwforce = 2
	slot_flags = SLOT_BELT

	key_type = /obj/item/clothing/mask/smokable/cigarette
	startswith = list(/obj/item/clothing/mask/smokable/cigarette = 6)

/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	atom_flags |= ATOM_FLAG_NO_REACT|ATOM_FLAG_OPEN_CONTAINER
	create_reagents(5 * max_storage_space)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == BP_MOUTH && contents.len > 0 && !user.wear_mask)
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = null
		for(var/obj/item/clothing/mask/smokable/cigarette/C in contents)
			cig = C
			break

		if(cig == null)
			to_chat(user, "<span class='notice'>Looks like the packet is out of cigarettes.</span>")
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
		to_chat(user, "<span class='notice'>You take a cigarette out of the pack.</span>")
		update_icon()
	else
		..()

/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "pack of Dromedary Co. cigarettes"
	desc = "A packet of six imported Dromedary Company cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\"."
	icon_state = "Dpacket"
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/dromedaryco = 6)

/obj/item/weapon/storage/fancy/cigarettes/killthroat
	name = "pack of Acme Co. cigarettes"
	desc = "A packet of six Acme Company cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/killthroat = 6)

/obj/item/weapon/storage/fancy/cigarettes/killthroat/New()
	..()
	fill_cigarre_package(src,list(/datum/reagent/fuel = 4))

// New exciting ways to kill your lungs! - Earthcrusher //

/obj/item/weapon/storage/fancy/cigarettes/luckystars
	name = "pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon_state = "LSpacket"
	item_state = "Dpacket" //I actually don't mind cig packs not showing up in the hand. whotf doesn't just keep them in their pockets/coats //
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/luckystars = 6)

/obj/item/weapon/storage/fancy/cigarettes/jerichos
	name = "pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon_state = "Jpacket"
	item_state = "Dpacket"
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/jerichos = 6)

/obj/item/weapon/storage/fancy/cigarettes/menthols
	name = "pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon_state = "TMpacket"
	item_state = "Dpacket"

	key_type = /obj/item/clothing/mask/smokable/cigarette/menthol
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/menthol = 6)

/obj/item/weapon/storage/fancy/cigarettes/carcinomas
	name = "pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too. Yes, actual cats."
	icon_state = "CApacket"
	item_state = "Dpacket"
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/carcinomas = 6)

/obj/item/weapon/storage/fancy/cigarettes/professionals
	name = "pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They taste disgusting, too."
	icon_state = "P100packet"
	item_state = "Dpacket"
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/professionals = 6)

//cigarellos
/obj/item/weapon/storage/fancy/cigarettes/cigarello
	name = "pack of Trident Original cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years."
	icon_state = "CRpacket"
	item_state = "Dpacket"
	max_storage_space = 5
	key_type = /obj/item/clothing/mask/smokable/cigarette/trident
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/trident = 5)

/obj/item/weapon/storage/fancy/cigarettes/cigarello/variety
	name = "pack of Trident Fruit cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. This is a fruit variety pack."
	icon_state = "CRFpacket"
	startswith = list(	/obj/item/clothing/mask/smokable/cigarette/trident/watermelon,
						/obj/item/clothing/mask/smokable/cigarette/trident/orange,
						/obj/item/clothing/mask/smokable/cigarette/trident/grape,
						/obj/item/clothing/mask/smokable/cigarette/trident/cherry,
						/obj/item/clothing/mask/smokable/cigarette/trident/berry)

/obj/item/weapon/storage/fancy/cigarettes/cigarello/mint
	name = "pack of Trident Menthol cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. These are the menthol variety."
	icon_state = "CRMpacket"
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/trident/mint = 5)

/obj/item/weapon/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigpacket"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7

	key_type = /obj/item/clothing/mask/smokable/cigarette/cigar
	startswith = list(/obj/item/clothing/mask/smokable/cigarette/cigar = 6)

/obj/item/weapon/storage/fancy/cigar/New()
	..()
	atom_flags |= ATOM_FLAG_NO_REACT
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
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12

	key_type = /obj/item/weapon/reagent_containers/glass/beaker/vial
	startswith = list(/obj/item/weapon/reagent_containers/glass/beaker/vial = 12)

/obj/item/weapon/storage/fancy/vials/on_update_icon()
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
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = null
	storage_slots = 12
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/on_update_icon()
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
	. = ..()
	update_icon()
