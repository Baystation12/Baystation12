/obj/item/clothing/mask/smokable/ecig
	name = "electronic cigarette"
	desc = "Device with modern approach to smoking."
	icon = 'icons/obj/ecig.dmi'
	var/active = 0
	//var/obj/item/weapon/cell/ec_cell = /obj/item/weapon/cell/device
	var/cartridge_type = /obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine
	var/obj/item/weapon/reagent_containers/ecig_cartridge/ec_cartridge
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("attacked", "poked", "battered")
	body_parts_covered = 0
	var/brightness_on = 1
	chem_volume = 0 //ecig has no storage on its own but has reagent container created by parent obj
	item_state = "ecigoff"
	var/icon_off
	var/icon_empty

/obj/item/clothing/mask/smokable/ecig/New()
	..()
	ec_cartridge = new cartridge_type(src)

/obj/item/clothing/mask/smokable/ecig/util
	name = "\improper ONI-55 electronic cigarette"
	desc = "Small metal cigarette-shaped device to satiate nicotine hunger. This one is ONI-55 model. "
	icon_state = "ecigoff1"
	icon_off = "ecigoff1"
	icon_empty = "ecigoff2"
	icon_on = "ecigon"

/obj/item/clothing/mask/smokable/ecig/deluxe
	name = "\improper eGavana MK3 electronic cigarette"
	desc = "Cigar-like device for those who like luxurous option. This one is eGavana MK3 model. "
	icon_state = "pcigoff1"
	icon_off = "pcigoff1"
	icon_empty = "pcigoff2"
	icon_on = "pcigon"

/obj/item/clothing/mask/smokable/ecig/simple
	name = "\improper Lucky 1337 electronic cigarette"
	desc = "Device for safe consuming of nicotine, made to look like regular cigarette. This one is Lucky 1337 model. "
	icon_state = "ccigoff"
	icon_off = "ccigoff"
	icon_empty = "ccigoff"
	icon_on = "ccigon"

/obj/item/clothing/mask/smokable/ecig/process()
	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc
		if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
			if (!active || !ec_cartridge || !ec_cartridge.reagents.total_volume)//no cartridge
				active=0//autodisable the cigarette
				GLOB.processing_objects.Remove(src)
				update_icon()
				return
			ec_cartridge.reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.4) // Most of it is not inhaled... balance reasons.

/obj/item/clothing/mask/smokable/ecig/update_icon()
	if (active)
		item_state = icon_on
		icon_state = icon_on
		set_light(brightness_on)
	else if (ec_cartridge)
		set_light(0)
		item_state = icon_off
		icon_state = icon_off
	else
		icon_state = icon_empty
		item_state = icon_empty
		set_light(0)
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_l_hand(0)
		M.update_inv_r_hand(1)


/obj/item/clothing/mask/smokable/ecig/attackby(var/obj/item/I, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/ecig_cartridge))
		if (ec_cartridge)//can't add second one
			to_chat(user, "<span class='notice'>There's already cartridge inside.</span> ")
		else//fits in new one
			user.remove_from_mob(I)
			I.forceMove(src)//I.loc=src
			ec_cartridge = I
			update_icon()
			to_chat(user, "<span class='notice'>You insert [I] into [src].</span> ")

/obj/item/clothing/mask/smokable/ecig/attack_self(mob/user as mob)
	if (active)
		active=0
		GLOB.processing_objects.Remove(src)
		to_chat(user, "<span class='notice'>You turn off [src]. </span> ")
		update_icon()
	else
		if (!ec_cartridge)
			to_chat(user, "<span class='notice'>Insert cartridge first.</span> ")
			return
		active=1
		GLOB.processing_objects.Add(src)
		to_chat(user, "<span class='notice'>You turn on [src]. </span> ")
		update_icon()

/obj/item/clothing/mask/smokable/ecig/attack_hand(mob/user as mob)//eject cartridge
	if(user.get_inactive_hand() == src)//if being hold
		if (ec_cartridge)
			active=0
			user.put_in_hands(ec_cartridge)
			to_chat(user, "<span class='notice'>You eject [ec_cartridge] from [src].</span> ")
			ec_cartridge = null
			update_icon()
	else
		..()

/obj/item/weapon/reagent_containers/ecig_cartridge
	name = "tobacco flavour cartridge"
	desc = "A small cartridge. Contains the liquid used in electronic cigarettes. Tobacco flavour. "
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/ecig.dmi'
	icon_state = "ecartridge"
	volume = 20
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/ecig_cartridge/New()
	create_reagents(volume)

/obj/item/weapon/reagent_containers/ecig_cartridge/examine(mob/user as mob)//to see how much left
	..()
	to_chat(user, "Has [reagents.total_volume] units of liquid remaining.")

/obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine
	name = "tobacco flavour cartridge"
	desc =  "A small cartridge. Contains the liquid used in electronic cigarettes. Tobacco flavour. "

/obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine/New()
	..()
	reagents.add_reagent(/datum/reagent/nicotine, 5)
	reagents.add_reagent(/datum/reagent/water, 15)

/obj/item/weapon/reagent_containers/ecig_cartridge/high_nicotine
	name = "high nicotine tobacco flavour cartridge"
	desc = "A small cartridge. Contains the liquid used in electronic cigarettes. Tobacco flavour with high content of nicotine. "

/obj/item/weapon/reagent_containers/ecig_cartridge/high_nicotine/New()
	..()
	reagents.add_reagent(/datum/reagent/nicotine, 10)
	reagents.add_reagent(/datum/reagent/water, 10)

/obj/item/weapon/reagent_containers/ecig_cartridge/orange
	name = "orange flavour cartridge"
	desc = "A small cartridge. Contains the liquid used in electronic cigarettes. Orange flavuor. "

/obj/item/weapon/reagent_containers/ecig_cartridge/orange/New()
	..()
	reagents.add_reagent(/datum/reagent/nicotine, 5)
	reagents.add_reagent(/datum/reagent/water, 10)
	reagents.add_reagent(/datum/reagent/drink/juice/orange, 5)

/obj/item/weapon/reagent_containers/ecig_cartridge/mint
	name = "mint flavour cartridge"
	desc = "A small cartridge. Contains the liquid used in electronic cigarettes. Mint flavuor. "

/obj/item/weapon/reagent_containers/ecig_cartridge/mint/New()
	..()
	reagents.add_reagent(/datum/reagent/nicotine, 5)
	reagents.add_reagent(/datum/reagent/water, 10)
	reagents.add_reagent(/datum/reagent/menthol, 5)

/obj/item/weapon/reagent_containers/ecig_cartridge/watermelon
	name = "watermelon flavour cartridge"
	desc = "A small cartridge. Contains the liquid used in electronic cigarettes. Watermelon flavuor. "

/obj/item/weapon/reagent_containers/ecig_cartridge/watermelon/New()
	..()
	reagents.add_reagent(/datum/reagent/nicotine, 5)
	reagents.add_reagent(/datum/reagent/water, 10)
	reagents.add_reagent(/datum/reagent/drink/juice/watermelon, 5)

/obj/item/weapon/reagent_containers/ecig_cartridge/grape
	name = "grape flavour cartridge"
	desc = "A small cartridge. Contains the liquid used in electronic cigarettes. Grape flavuor. "


/obj/item/weapon/reagent_containers/ecig_cartridge/grape/New()
	..()
	reagents.add_reagent(/datum/reagent/nicotine, 5)
	reagents.add_reagent(/datum/reagent/water, 10)
	reagents.add_reagent(/datum/reagent/drink/juice/grape, 5)