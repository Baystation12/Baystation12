//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = 4
	max_w_class = 3
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 4
	req_access = list(access_armory)
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/card/id))
			if(src.broken)
				user << "<span class='warning'>It appears to be broken.</span>"
				return
			if(src.allowed(user))
				src.locked = !( src.locked )
				if(src.locked)
					src.icon_state = src.icon_locked
					user << "<span class='notice'>You lock \the [src]!</span>"
					return
				else
					src.icon_state = src.icon_closed
					user << "<span class='notice'>You unlock \the [src]!</span>"
					return
			else
				user << "<span class='warning'>Access Denied</span>"
		else if((istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy/blade)) && !src.broken)
			broken = 1
			locked = 0
			desc = "It appears to be broken."
			icon_state = src.icon_broken
			if(istype(W, /obj/item/weapon/melee/energy/blade))
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, src.loc)
				spark_system.start()
				playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
				playsound(src.loc, "sparks", 50, 1)
				for(var/mob/O in viewers(user, 3))
					O.show_message(text("<span class='warning'>The locker has been sliced open by [] with an energy blade!</span>", user), 1, text("<span class='warning'>You hear metal being sliced and sparks flying.</span>"), 2)
			else
				for(var/mob/O in viewers(user, 3))
					O.show_message(text("<span class='warning'>The locker has been broken by [] with an electromagnetic card!</span>", user), 1, text("You hear a faint electrical spark."), 2)

		if(!locked)
			..()
		else
			user << "<span class='warning'>It's locked!</span>"
		return


	show_to(mob/user as mob)
		if(locked)
			user << "<span class='warning'>It's locked!</span>"
		else
			..()
		return


/obj/item/weapon/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)

	New()
		..()
		new /obj/item/weapon/implantcase/loyalty(src)
		new /obj/item/weapon/implantcase/loyalty(src)
		new /obj/item/weapon/implantcase/loyalty(src)
		new /obj/item/weapon/implanter/loyalty(src)


/obj/item/weapon/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)

	New()
		..()
		new /obj/item/weapon/grenade/flashbang/clusterbang(src)
