/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/structures/extinguisher.dmi'
	icon_state = "extinguisher_closed"
	anchored = TRUE
	density = FALSE
	var/obj/item/extinguisher/has_extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/New()
	..()
	has_extinguisher = new/obj/item/extinguisher(src)


/obj/structure/extinguisher_cabinet/use_tool(obj/item/tool, mob/user, list/click_params)
	// Extinguisher - Put in cabinet
	if (istype(tool, /obj/item/extinguisher))
		if (!opened)
			USE_FEEDBACK_FAILURE("\The [src] is closed.")
			return TRUE
		if (has_extinguisher)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [has_extinguisher].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		has_extinguisher = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] places \a [tool] in \the [src]."),
			SPAN_NOTICE("You place \the [tool] in \the [src].")
		)
		return TRUE

	return ..()


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)
	if(isrobot(user))
		return
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
			return
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, SPAN_NOTICE("You take [has_extinguisher] from [src]."))
		playsound(src.loc, 'sound/effects/extout.ogg', 50, 0)
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/on_update_icon()
	if(!opened)
		icon_state = "extinguisher_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/extinguisher/mini))
			icon_state = "extinguisher_mini"
		else
			icon_state = "extinguisher_full"
	else
		icon_state = "extinguisher_empty"

/obj/structure/extinguisher_cabinet/AltClick(mob/user)
	if(CanPhysicallyInteract(user))
		opened = !opened
		update_icon()
		return TRUE
	return FALSE

/obj/structure/extinguisher_cabinet/do_simple_ranged_interaction(mob/user)
	if(has_extinguisher)
		has_extinguisher.dropInto(loc)
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()
	return TRUE
