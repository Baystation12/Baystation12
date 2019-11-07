/obj/item/weapon/weldpack
	name = "welding kit"
	desc = "An unwieldy, heavy backpack with two massive fuel tanks. Includes a connector for most models of portable welding tools."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	w_class = ITEM_SIZE_HUGE
	var/max_fuel = 350
	var/obj/item/weapon/weldingtool/welder

/obj/item/weapon/weldpack/Initialize()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)

	. = ..()

/obj/item/weapon/weldpack/Destroy()
	QDEL_NULL(welder)

	. = ..()

/obj/item/weapon/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W))
		var/obj/item/weapon/weldingtool/T = W
		if(T.welding & prob(50))
			log_and_message_admins("triggered a fueltank explosion.", user)
			to_chat(user, "<span class='danger'>That was stupid of you.</span>")
			explosion(get_turf(src),-1,0,2)
			if(src)
				qdel(src)
			return
		else
			if(T.welding)
				to_chat(user, "<span class='danger'>That was close!</span>")
			if(!T.tank)
				to_chat(user, "\The [T] has no tank attached!")
			src.reagents.trans_to_obj(T.tank, T.tank.max_fuel)
			to_chat(user, "<span class='notice'>You refuel \the [W].</span>")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
	else if(istype(W, /obj/item/weapon/welder_tank))
		var/obj/item/weapon/welder_tank/tank = W
		src.reagents.trans_to_obj(tank, tank.max_fuel)
		to_chat(user, "<span class='notice'>You refuel \the [W].</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	to_chat(user, "<span class='warning'>The tank will accept only a welding tool or cartridge.</span>")
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

/obj/item/weapon/weldpack/attack_hand(mob/user as mob)
	if(welder && user.get_inactive_hand() == src)
		user.put_in_hands(welder)
		user.visible_message("[user] removes \the [welder] from \the [src].", "You remove \the [welder] from \the [src].")
		welder = null
		update_icon()
	else
		..()

/obj/item/weapon/weldpack/on_update_icon()
	..()

	overlays.Cut()
	if(welder)
		var/image/welder_image = image(welder.icon, icon_state = welder.icon_state)
		welder_image.pixel_x = 16
		overlays += welder_image

/obj/item/weapon/weldpack/examine(mob/user)
	. = ..()
	to_chat(user, text("\icon[] [] units of fuel left!", src, src.reagents.total_volume))

	if(welder)
		to_chat(user, "\The [welder] is attached.")
