
//Limited use boxes of disposables, like tissues, gloves, communist manifestos.
//prototyping, need to make a master-type for subsequent items, such as matchbooks,
//Core/parent item below
/obj/item/weapon/dispenser
	name = "dispenser"
	desc = "You shouldn't see this."
	icon = 'icons/obj/disposables.dmi'
	icon_state = "dispenser"
	item_state = "generic_dispenser"
	var/charges = 5
	var/trash = /obj/item/trash/tissues
	var/item = /obj/item/whatnots

/obj/item/whatnots

/obj/item/weapon/dispenser/proc/get_trash(turf/location)
	if(trash && ispath(trash,/obj/item))
		return new trash(location)

/obj/item/weapon/dispenser/proc/handle_click(mob/user)
	if(charges > 0)
		var/obj/item/C = new item(get_turf(loc))
		if (user.put_in_hands(C))
			user.visible_message("\The [user] picks \a [C] from [src].", "You pick \a [C] from \the [src].")
		else
			user.visible_message("\The [user] tries to remove \a [C] from [src], but drops it.", "You try to remove \a [C] from \the [src], but you drop it. Oops.")
		charges--
	else
		to_chat(user, "\The [src] is depleted.")
		var/obj/item/T = get_trash(get_turf(loc))
		if(T)
			user.put_in_hands(T)
		qdel(src)

/obj/item/weapon/dispenser/attack_self(mob/user)
	handle_click(user)

/obj/item/weapon/dispenser/AltClick(mob/user)
	if (user.stat)
		to_chat(usr, "How do you propose doing that in your current state?")
		return
	if (!Adjacent(user))
		to_chat(user, "You're too far away from [src].")
		return
	handle_click(user)
//descendant items below

/obj/item/weapon/dispenser/gloves
	name = "glove dispenser"
	desc = "Small dispenser of disposable medical grade gloves."
	icon_state = "glovebox"
	trash = /obj/item/trash/glovebox
	charges = 12
	item = /obj/item/clothing/gloves/latex

/obj/item/weapon/dispenser/tissues
	name = "box of wet wipes"
	desc = "A box of wet wipes, unscented."
	icon_state = "tissues"
	charges = 20
	trash = /obj/item/trash/tissues
	item = /obj/item/weapon/paper/crumpled/wipe

/obj/item/weapon/paper/crumpled/wipe
	name = "wet wipe"
	desc = "A single sheet of single use wet wipe. Unscented."
	icon = 'icons/obj/disposables.dmi'
	icon_state = "tissue_sheet"
