/////////
//ZIPPO//
/////////
/obj/item/weapon/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = 1
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/base_state

/obj/item/weapon/flame/lighter/light()
	if(!..())
		return 0
	set_light(2)
	return 1

/obj/item/weapon/flame/lighter/die()
	if(!..())
		return 0
	set_light(0)
	return 1


/obj/item/weapon/flame/lighter/proc/do_lit_message(var/mob/living/user)
	if(prob(95))
		user.visible_message("<span class='notice'>After a few attempts, \the [user] manages to light \the [src].</span>")
		return
	user << "<span class='danger'>You burn yourself while lighting the lighter.</span>"
	if(user.l_hand == src)
		user.apply_damage(2,BURN,"l_hand")
	else
		user.apply_damage(2,BURN,"r_hand")
	user.visible_message("<span class='danger'>\The [user] manages to light \the [src], burning their finger in the process.</span>")

/obj/item/weapon/flame/lighter/proc/do_snuff_message(var/mob/user)
	user.visible_message("<span class='notice'>\The [user] shuts off \the [src].</span>")

/obj/item/weapon/flame/lighter/update_icon()
	if(!base_state)
		base_state = icon_state
	if(lit)
		icon_state = "[base_state]on"
		item_state = "[base_state]on"
	else
		icon_state = "[base_state]"
		item_state = "[base_state]"

/obj/item/weapon/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"

/obj/item/weapon/flame/lighter/zippo/do_lit_message(var/mob/user)
	user.visible_message("<span class='notice'>\The [user] flips open and lights \the [src] in one smooth movement.</span>")

/obj/item/weapon/flame/lighter/zippo/do_snuff_message(var/mob/user)
	user.visible_message("<span class='notice'>You hear a quiet click as \the [user] shuts off \the [src].</span>")

/obj/item/weapon/flame/lighter/random/New()
	..()
	icon_state = "lighter-[pick("r","c","y","g")]"
	item_state = icon_state
	base_state = icon_state

/obj/item/weapon/flame/lighter/attack_self(var/mob/living/user)
	if(!lit)
		if(light())
			do_lit_message(user)
			return
	else
		if(die())
			do_snuff_message(user)
			return
	return ..()

/obj/item/weapon/flame/lighter/attack(var/mob/living/carbon/M, var/mob/living/carbon/user)
	if(istype(M))
		M.IgniteMob()
		if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == "mouth" && lit)
			var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
			if(M == user)
				cig.attackby(src, user)
			else
				cig.light("<span class='notice'>\The [user] holds the \the [src] out for \the [M] and lights \the [cig].</span>")
			return
	return ..()