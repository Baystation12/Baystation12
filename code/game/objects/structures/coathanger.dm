/obj/structure/coatrack
	name = "coat rack"
	desc = "Rack that holds coats."
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack0"
	var/obj/item/clothing/suit/coat
	var/list/allowed = list(/obj/item/clothing/suit/storage/toggle/labcoat, /obj/item/clothing/suit/storage/det_trench)

/obj/structure/coatrack/attack_hand(mob/user as mob)
	user.visible_message("[user] takes [coat] off \the [src].", "You take [coat] off the \the [src]")
	if(!user.put_in_active_hand(coat))
		coat.dropInto(user.loc)
	coat = null
	update_icon()


/obj/structure/coatrack/use_tool(obj/item/tool, mob/user, list/click_params)
	// Anything - Attempt to hang item
	if (is_type_in_list(tool, allowed))
		if (coat)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [coat] on it.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		coat = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] hangs \a [tool] on \the [src]."),
			SPAN_NOTICE("You hang \the [tool] on \the [src].")
		)
		return TRUE

	return ..()


/obj/structure/coatrack/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	var/can_hang = 0
	for (var/T in allowed)
		if(istype(mover,T))
			can_hang = 1

	if (can_hang && !coat)
		src.visible_message("[mover] lands on \the [src].")
		coat = mover
		coat.forceMove(src)
		update_icon()
		return 0
	else
		return 1

/obj/structure/coatrack/on_update_icon()
	overlays.Cut()
	if (istype(coat, /obj/item/clothing/suit/storage/toggle/labcoat))
		overlays += image(icon, icon_state = "coat_lab")
	if (istype(coat, /obj/item/clothing/suit/storage/toggle/labcoat/cmo))
		overlays += image(icon, icon_state = "coat_cmo")
	if (istype(coat, /obj/item/clothing/suit/storage/det_trench))
		overlays += image(icon, icon_state = "coat_det")
