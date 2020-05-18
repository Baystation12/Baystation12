/obj/item/weapon/material/lock_construct
	name = "lock"
	desc = "a crude but useful lock and bolt."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebinemag"
	w_class = ITEM_SIZE_TINY
	var/lock_data

/obj/item/weapon/material/lock_construct/New()
	..()
	force = 0
	throwforce = 0
	lock_data = generateRandomString(round(material.integrity/50))

/obj/item/weapon/material/lock_construct/attackby(var/obj/item/I, var/mob/user)
	if(istype(I,/obj/item/weapon/key))
		var/obj/item/weapon/key/K = I
		if(!K.key_data)
			to_chat(user, "<span class='notice'>You fashion \the [I] to unlock \the [src]</span>")
			K.key_data = lock_data
		else
			to_chat(user, "<span class='warning'>\The [I] already unlocks something...</span>")
		return
	if(istype(I,/obj/item/weapon/material/lock_construct))
		var/obj/item/weapon/material/lock_construct/L = I
		src.lock_data = L.lock_data
		to_chat(user, "<span class='notice'>You copy the lock from \the [L] to \the [src], making them identical.</span>")
		return
	..()

/obj/item/weapon/material/lock_construct/proc/create_lock(var/atom/target, var/mob/user)
	. = new /datum/lock(target,lock_data)
	user.visible_message("\The [user] attaches \the [src] to \the [target]")
	qdel(src)