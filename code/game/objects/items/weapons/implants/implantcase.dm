//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	var/obj/item/weapon/implant/imp = null

/obj/item/weapon/implantcase/Initialize()
	if(ispath(imp))
		imp = new imp(src)
		desc = "A case containing \a [imp]."
	. = ..()

/obj/item/weapon/implantcase/update_icon()
	if (imp)
		icon_state = "implantcase-[imp.implant_color]"
	else
		icon_state = "implantcase-0"
	return

/obj/item/weapon/implantcase/attackby(obj/item/weapon/I, mob/user)
	if (istype(I, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", src.name, null)
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			name = "glass case - '[t]'"
			desc = "A case containing \a [t] implant."
		else
			name = "glass case"
			desc = "A case containing an implant."
	else if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		if(istype(imp,/obj/item/weapon/implant/chem))
			imp.attackby(I,user)
	else if (istype(I, /obj/item/weapon/implanter))
		var/obj/item/weapon/implanter/M = I
		if (M.imp && !imp && !M.imp.implanted)
			M.imp.forceMove(src)
			imp = M.imp
			M.imp = null
		else if (imp && !M.imp)
			imp.forceMove(M)
			M.imp = src.imp
			imp = null
		update_icon()
		M.update_icon()
	else if (istype(I, /obj/item/weapon/implant))
		to_chat(usr, "<span class='notice'>You slide \the [I] into \the [src].</span>")
		user.drop_from_inventory(I,src)
		imp = I
		update_icon()
	else
		return ..()