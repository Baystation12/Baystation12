//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/tools/implanter.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	var/obj/item/implant/imp = null

/obj/item/implantcase/New()
	if(ispath(imp))
		imp = new imp(src)
		update_description()
	..()
	update_icon()

/obj/item/implantcase/proc/update_description()
	if (imp)
		desc = "A case containing \a [imp]."
		origin_tech = imp.origin_tech
	else
		desc = "A case for implants."
		origin_tech.Cut()

/obj/item/implantcase/on_update_icon()
	if (imp)
		icon_state = "implantcase-[imp.implant_color]"
	else
		icon_state = "implantcase-0"
	return

/obj/item/implantcase/use_tool(obj/item/I, mob/living/user, list/click_params)
	if (istype(I, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", src.name, null)
		if (user.get_active_hand() != I)
			return TRUE
		if((!in_range(src, usr) && loc != user))
			return TRUE
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			SetName("glass case - '[t]'")
			desc = "A case containing \a [t] implant."
		else
			SetName(initial(name))
			desc = "A case containing an implant."
		return TRUE

	else if(istype(I, /obj/item/reagent_containers/syringe))
		if(istype(imp,/obj/item/implant/chem))
			imp.use_tool(I,user)
			return TRUE

	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if (M.imp && !imp && !M.imp.implanted)
			M.imp.forceMove(src)
			imp = M.imp
			M.imp = null
		else if (imp && !M.imp)
			imp.forceMove(M)
			M.imp = src.imp
			imp = null
		update_description()
		update_icon()
		M.update_icon()
		return TRUE

	else if (istype(I, /obj/item/implant) && user.unEquip(I, src))
		to_chat(usr, SPAN_NOTICE("You slide \the [I] into \the [src]."))
		imp = I
		update_description()
		update_icon()
		return TRUE

	return ..()
