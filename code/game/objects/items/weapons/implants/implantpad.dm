//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/implantpad
	name = "implant pad"
	desc = "Used to reprogramm implants."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	var/obj/item/weapon/implantcase/case = null

/obj/item/weapon/implantpad/update_icon()
	if (case)
		icon_state = "implantpad-1"
	else
		icon_state = "implantpad-0"

/obj/item/weapon/implantpad/attack_hand(mob/user)
	if ((case && (user.l_hand == src || user.r_hand == src)))
		user.put_in_active_hand(case)

		case.add_fingerprint(user)
		case = null

		add_fingerprint(user)
		update_icon()
	else
		return ..()

/obj/item/weapon/implantpad/attackby(obj/item/weapon/implantcase/C, mob/user)
	..()
	if(istype(C, /obj/item/weapon/implantcase))
		if(!( case ))
			user.drop_item()
			C.loc = src
			case = C
	update_icon()

/obj/item/weapon/implantpad/attack_self(mob/user)
	if (case)
		if(case.imp)
			case.imp.interact(user)
		else
			to_chat(user,"The implant casing is empty.")
	else
		to_chat(user,"<span class='warning'>There's no implant case in \the [src].</span>")