/obj/item/weapon/material/lock_construct
	name = "lock"
	desc = "a crude but useful lock and bolt."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largebinemag"
	w_class = 1
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
			user << "<span class='notice'>You fashion \the [I] to unlock \the [src]</span>"
			K.key_data = lock_data
		else
			user << "<span class='warning'>\The [I] already unlocks something...</span>"
		return
	..()

/obj/item/weapon/material/lock_construct/proc/create_lock(var/atom/target, var/mob/user)
	. = new /datum/lock(target,lock_data)
	user.drop_item(src)
	user.visible_message("\The [user] attaches \the [src] to \the [target]")
	qdel(src)