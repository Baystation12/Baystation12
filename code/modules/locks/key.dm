/obj/item/key
	name = "key"
	desc = "Used to unlock things."
	icon = 'icons/obj/items.dmi'
	icon_state = "keys"
	w_class = 1
	var/key_data = ""

/obj/item/key/New(newloc,data)
	if(data)
		key_data = data
	..(newloc)

/obj/item/key/proc/get_data(mob/user)
	return key_data

/obj/item/key/soap
	name = "soap key"
	desc = "a fragile key made using a bar of soap."
	var/uses = 0

/obj/item/key/soap/get_data(mob/user)
	uses--
	if(uses == 1)
		to_chat(user, SPAN_WARNING("\The [src] is going to break soon!"))
	else if(uses <= 0)
		to_chat(user, SPAN_WARNING("\The [src] crumbles in your hands."))
		qdel(src)
	return ..()
