////////////////////////////////////////////////////////////////////////////////
/// Gel Jars.
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/gel
	name = "tube"
	desc = "A small tube."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "gel_jar"
	item_state = "gel_jar"
	amount_per_transfer_from_this = 5
	volume = 120
	w_class = ITEM_SIZE_TINY
	flags = OPENCONTAINER
	unacidable = 1
	var/reagent_name = "gel"

/obj/item/weapon/reagent_containers/gel/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/gel/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/gel/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/gel/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/gel/New()
	..()
	flags ^= OPENCONTAINER

/obj/item/weapon/reagent_containers/gel/examine(var/mob/user)
	if(!..(user, 2))
		return
	if(reagents && reagents.reagent_list.len)
		to_chat(user, "<span class='notice'>\The [src.name] contains [reagents.total_volume] units of [src.reagent_name].</span>")
	else
		to_chat(user, "<span class='notice'>\The [src.name] is empty.</span>")
	if(!is_open_container())
		to_chat(user, "<span class='notice'>The lid is screwed tight.</span>")

/obj/item/weapon/reagent_containers/gel/attack_self(user as mob)
	..()
	if(is_open_container())
		to_chat(user, "<span class='notice'>You put the lid on the [src].</span>")
		flags ^= OPENCONTAINER
	else
		to_chat(user, "<span class='notice'>You take the lid off of the [src].</span>")
		flags |= OPENCONTAINER
	update_icon()

/obj/item/weapon/reagent_containers/gel/afterattack(var/obj/target, var/mob/user, var/proximity)

	if(!proximity)
		return

	if(reagents && reagents.reagent_list.len)

		if(!ismob(target))
			return

		var/time = 10	//1/3rds the amount of time a syringe takes.
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(istype(target, /mob/living/carbon/human))

			if(!affecting)
				to_chat(user, "<span class='warning'>\The [target] is missing that body part!</span>")
				return

			if(affecting.organ_tag == BP_HEAD)
				if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
					to_chat(user, "<span class='warning'>You can't apply \the [src.reagent_name] through [H.head]!</span>")
					return
			else
				if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
					to_chat(user, "<span class='warning'>You can't apply \the [src.reagent_name] through [H.wear_suit]!</span>")
					return

			if(affecting.robotic >= ORGAN_ROBOT)
				to_chat(user, "<span class='warning'>\The [src.reagent_name] isn't useful at all on a robotic limb..</span>")
				return

			user.visible_message(	\
				"<span class='notice'>[user] starts rubbing something onto [target]'s [affecting].</span>", \
				"<span class='notice'>You start rubbing [src.reagent_name] on [target].</span>"	\
			)

			if(!do_mob(user, target, time))
				return

			var/contained = reagentlist()
			admin_attack_log(	\
				user, H, "Rubbed [src.reagent_name] all over their victim. (Reagents: [contained])", \
				"Were rubbed with [src.reagent_name] (Reagents: [contained])", \
				"used /a [src.name] (Reagents: [contained]) to rub [src.reagent_name] on"	\
			)

			var/trans = reagents.trans_to(target, amount_per_transfer_from_this)

			user.visible_message(	\
				"<span class='notice'>[user] rubs something on [target]'s [affecting].</span>", \
				"<span class='notice'>You transfer [trans] units of the [src.reagent_name].</span>"	\
			)
			update_icon()


	else
		to_chat(user, "<span class='notice'>\The [src.name] is empty.</span>")
		return

/obj/item/weapon/reagent_containers/gel/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]_full")

		if(!reagents.total_volume)
			filling.icon_state = "[icon_state]_empty"
		else
			filling.icon_state = "[icon_state]_full"

		filling.color = reagents.get_color()
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

////////////////////////////////////////////////////////////////////////////////
/// Gel Jars. END
////////////////////////////////////////////////////////////////////////////////