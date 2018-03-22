/obj/item/weapon/lipstick
	gender = PLURAL
	name = "red lipstick"
	desc = "A generic brand of lipstick."
	icon = 'icons/obj/items.dmi'
	icon_state = "lipstick"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/colour = "red"
	var/open = 0


/obj/item/weapon/lipstick/purple
	name = "purple lipstick"
	colour = "purple"

/obj/item/weapon/lipstick/jade
	name = "jade lipstick"
	colour = "jade"

/obj/item/weapon/lipstick/black
	name = "black lipstick"
	colour = "black"


/obj/item/weapon/lipstick/random
	name = "lipstick"

/obj/item/weapon/lipstick/random/New()
	colour = pick("red","purple","jade","black")
	name = "[colour] lipstick"


/obj/item/weapon/lipstick/attack_self(mob/user as mob)
	to_chat(user, "<span class='notice'>You twist \the [src] [open ? "closed" : "open"].</span>")
	open = !open
	if(open)
		icon_state = "[initial(icon_state)]_[colour]"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/lipstick/attack(atom/A, mob/user as mob, target_zone)
	if(!open)	return

	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/head/head = H.organs_by_name[BP_HEAD]

		if(!istype(head))
			return

		if(user.a_intent == I_HELP && target_zone == BP_HEAD)
			head.write_on(user, src.name)
		else if(head.has_lips)
			if(H.lip_style)	//if they already have lipstick on
				to_chat(user, "<span class='notice'>You need to wipe off the old lipstick first!</span>")
				return
			if(H == user)
				user.visible_message("<span class='notice'>[user] does their lips with \the [src].</span>", \
									 "<span class='notice'>You take a moment to apply \the [src]. Perfect!</span>")
				H.lip_style = colour
				H.update_body()
			else
				user.visible_message("<span class='warning'>[user] begins to do [H]'s lips with \the [src].</span>", \
									 "<span class='notice'>You begin to apply \the [src].</span>")
				if(do_after(user, 20, H) && do_after(H, 20, needhand = 0, progress = 0, incapacitation_flags = INCAPACITATION_NONE))	//user needs to keep their active hand, H does not.
					user.visible_message("<span class='notice'>[user] does [H]'s lips with \the [src].</span>", \
										 "<span class='notice'>You apply \the [src].</span>")
					H.lip_style = colour
					H.update_body()
	else if(istype(A, /obj/item/organ/external/head))
		var/obj/item/organ/external/head/head = A
		head.write_on(user, src)

//you can wipe off lipstick with paper! see code/modules/paperwork/paper.dm, paper/attack()


/obj/item/weapon/haircomb //sparklysheep's comb
	name = "plastic comb"
	desc = "A pristine comb made from flexible plastic."
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/items.dmi'
	icon_state = "comb"
	item_state = "comb"

/obj/item/weapon/haircomb/attack_self(mob/user)
	user.visible_message("<span class='notice'>[user] uses [src] to comb their hair with incredible style and sophistication. What a [user.gender == FEMALE ? "lady" : "guy"].</span>")