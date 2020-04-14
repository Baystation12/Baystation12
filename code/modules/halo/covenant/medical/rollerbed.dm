
//Roller Beds

/obj/structure/bed/roller/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'

/obj/structure/bed/roller/covenant/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench) || istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	else if(istype(W,/obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
		else
			visible_message("[user] collapses \the [src.name].")
			new/obj/item/roller/covenant(get_turf(src))
			spawn(0)
				qdel(src)
		return
	..()

/obj/structure/bed/roller/covenant/MouseDrop(over_object, src_location, over_location)
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		visible_message("[usr] collapses \the [src.name].")
		new/obj/item/roller/covenant(get_turf(src))
		spawn(0)
			qdel(src)
		return

/obj/item/roller/covenant
	icon = 'code/modules/halo/covenant/medical/medical.dmi'

/obj/item/roller/covenant/attack_self(mob/user)
		var/obj/structure/bed/roller/covenant/R = new /obj/structure/bed/roller/covenant(user.loc)
		R.add_fingerprint(user)
		qdel(src)
