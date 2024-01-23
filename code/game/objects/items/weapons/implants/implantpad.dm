//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantpad
	name = "implant pad"
	desc = "Used to reprogramm implants."
	icon = 'icons/obj/tools/implanter.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	var/obj/item/implant/imp

/obj/item/implantpad/on_update_icon()
	if (imp)
		icon_state = "implantpad-1"
	else
		icon_state = "implantpad-0"

/obj/item/implantpad/attack_hand(mob/user)
	if (imp && user.IsHolding(src))
		user.put_in_active_hand(imp)
		imp.add_fingerprint(user)
		add_fingerprint(user)

		imp = null
		update_icon()
	else
		return ..()

/obj/item/implantpad/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/implantcase))
		var/obj/item/implantcase/C = I
		if(!imp && C.imp)
			C.imp.forceMove(src)
			imp = C.imp
			C.imp = null
		else if (imp && !C.imp)
			imp.forceMove(C)
			C.imp = imp
			imp = null
		C.update_icon()
		update_icon()
		return TRUE

	else if(istype(I, /obj/item/implanter))
		var/obj/item/implanter/C = I
		if(!imp && C.imp)
			C.imp.forceMove(src)
			imp = C.imp
			C.imp = null
		else if (imp && !C.imp)
			imp.forceMove(C)
			C.imp = imp
			imp = null
		C.update_icon()
		update_icon()
		return TRUE

	else if(istype(I, /obj/item/implant) && user.unEquip(I, src))
		imp = I
		update_icon()
		return TRUE

	return ..()

/obj/item/implantpad/attack_self(mob/user)
	if (imp)
		imp.interact(user)
	else
		to_chat(user,SPAN_WARNING("There's no implant loaded in \the [src]."))
