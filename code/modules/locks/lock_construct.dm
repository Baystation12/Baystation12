/obj/item/material/lock_construct
	name = "lock"
	desc = "a crude but useful lock and bolt."
	icon = 'icons/obj/items.dmi'
	icon_state = "lock"
	w_class = ITEM_SIZE_TINY
	var/lock_data

/obj/item/material/lock_construct/New()
	..()
	force = 0
	throwforce = 0
	lock_data = generateRandomString(round(material.integrity/50))

/obj/item/material/lock_construct/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/key))
		var/obj/item/key/K = I
		if(!K.key_data)
			to_chat(user, SPAN_NOTICE("You fashion \the [I] to unlock \the [src]"))
			K.key_data = lock_data
		else
			to_chat(user, SPAN_WARNING("\The [I] already unlocks something..."))
		return
	if(istype(I,/obj/item/material/lock_construct))
		var/obj/item/material/lock_construct/L = I
		src.lock_data = L.lock_data
		to_chat(user, SPAN_NOTICE("You copy the lock from \the [L] to \the [src], making them identical."))
		return
	..()

/obj/item/material/lock_construct/proc/create_lock(atom/target, mob/user)
	. = new /datum/lock(target,lock_data)
	user.visible_message("\The [user] attaches \the [src] to \the [target]")
	qdel(src)
