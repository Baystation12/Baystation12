/obj/item/weapon/weldpack
	name = "Welding kit"
	desc = "A heavy-duty, portable welding fluid carrier."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	w_class = ITEM_SIZE_LARGE
	var/max_fuel = 350

/obj/item/weapon/weldpack/New()
	var/datum/reagents/R = new/datum/reagents(max_fuel) //Lotsa refills
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)

/obj/item/weapon/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/T = W
		if(T.welding & prob(50))
			message_admins("[key_name_admin(user)] triggered a fueltank explosion.")
			log_game("[key_name(user)] triggered a fueltank explosion.")
			to_chat(user, "<span class='danger'>That was stupid of you.</span>")
			explosion(get_turf(src),-1,0,2)
			if(src)
				qdel(src)
			return
		else
			if(T.welding)
				to_chat(user, "<span class='danger'>That was close!</span>")
			src.reagents.trans_to_obj(W, T.max_fuel)
			to_chat(user, "<span class='notice'>Welder refilled!</span>")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
	to_chat(user, "<span class='warning'>The tank scoffs at your insolence. It only provides services to welders.</span>")
	return

/obj/item/weapon/weldpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>You crack the cap off the top of the pack and fill it back up again from the tank.</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, "<span class='warning'>The pack is already full!</span>")
		return

/obj/item/weapon/weldpack/examine(mob/user)
	. = ..(user)
	to_chat(user, text("\icon[] [] units of fuel left!", src, src.reagents.total_volume))
	return
