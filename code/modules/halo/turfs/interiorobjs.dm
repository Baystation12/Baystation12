// Contains:
// Gavel Hammer
// Gavel Block

/obj/item/weapon/gavelhammer
	name = "gavel hammer"
	desc = "Order, order! No bombs in my courthouse."
	icon = 'maps/geminus_city/citymap_icons/items.dmi'
	icon_state = "gavelhammer"
	force = 5
	throwforce = 6
	w_class = 2
	attack_verb = list("bashed", "battered", "judged", "whacked")
//	burn_state = 0 //Burnable



/obj/item/weapon/gavelblock
	name = "gavel block"
	desc = "Smack it with a gavel hammer when the civilians get rowdy."
	icon = 'maps/geminus_city/citymap_icons/items.dmi'
	icon_state = "gavelblock"
	force = 2
	throwforce = 2
	w_class = 1
//	burn_state = 0 //Burnable

/obj/item/weapon/gavelblock/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/gavelhammer))
		playsound(loc, 'maps/geminus_city/citymap_sounds/gavel.ogg', 100, 1)
		user.visible_message("<span class='warning'>[user] strikes \the [src] with \the [I].</span>")

	else
		return


/obj/item/weapon/deskbell
	name = "desk bell"
	desc = "An annoying bell. Ring for service."
	icon = 'maps/geminus_city/citymap_icons/objects.dmi'
	icon_state = "deskbell"
	force = 2
	throwforce = 2
	w_class = 2.0
	attack_verb = list("annoyed")


/obj/item/weapon/deskbell/attack(mob/target as mob, mob/living/user as mob)
	playsound(loc, 'maps/geminus_city/citymap_sounds/deskbell.ogg', 100, 1, -1)
	..()

/obj/item/weapon/deskbell/attack_hand(mob/user as mob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(H,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return

	if(user.a_intent == "hurt")
		playsound(user.loc, 'maps/geminus_city/citymap_sounds/deskbell_rude.ogg', 50, 1)
	else
		playsound(user.loc, 'maps/geminus_city/citymap_sounds/deskbell.ogg', 50, 1)

	add_fingerprint(user)
	return


/obj/item/weapon/deskbell/attackby(obj/item/i as obj, mob/user as mob, params)
	if(!istype(i))
		return
	playsound(user.loc, 'maps/geminus_city/citymap_sounds/deskbell.ogg', 50, 1)

/obj/structure/closet/wardrobe/police
	name = "GCPD locker"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/police/New()
	..()
	new /obj/item/clothing/head/soft/sec/corp(src)
	new /obj/item/clothing/head/beret/sec/corporate/hos(src)
	new /obj/item/clothing/under/police(src)
	new /obj/item/clothing/suit/storage/vest/nt(src)
	new /obj/item/clothing/shoes/dutyboots(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/device/flash(src)
	new /obj/item/weapon/grenade/chem_grenade/teargas(src)
	new /obj/item/weapon/grenade/flashbang(src)
	new /obj/item/weapon/melee/baton/humbler(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/clothing/accessory/badge/police(src)
	new /obj/item/device/flashlight/glowstick/yellow(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/storage/belt/security(src)
	new /obj/item/ammo_magazine/m127_saphp(src)
	new /obj/item/ammo_magazine/m5/rubber(src)
	new /obj/item/weapon/gun/projectile/m6c_magnum_s(src)
	return