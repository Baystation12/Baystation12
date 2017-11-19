/obj/item/weapon/weldpack
	name = "welding kit"
	desc = "An unwieldy, heavy backpack with two massive fuel tanks. Includes a connector for most models of portable welding tools."
	description_info = "This pack acts as a portable source of welding fuel. Use a welder on it to refill its tank - but make sure it's not lit! You can use this kit on a fuel tank or appropriate reagent dispenser to replenish its reserves."
	description_fluff = "The Shenzhen Chain of 2380 was an industrial accident of noteworthy infamy that occurred at Earth's L3 Lagrange Point. An apprentice welder, working for the Shenzhen Space Fabrication Group, failed to properly seal her fuel port, triggering a chain reaction that spread from laborer to laborer, instantly vaporizing a crew of fourteen. Don't let this happen to you!"
	description_antag = "In theory, you could hold an open flame to this pack and produce some pretty catastrophic results. The trick is getting out of the blast radius."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	w_class = ITEM_SIZE_LARGE
	var/max_fuel = 350

/obj/item/weapon/weldpack/New()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)

/obj/item/weapon/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W))
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
			if(!T.tank)
				to_chat(user, "\The [T] has no tank attached!")
			src.reagents.trans_to_obj(T.tank, T.tank.max_fuel)
			to_chat(user, "<span class='notice'>You refuel \the [W].</span>")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
	else if(istype(W, /obj/item/weapon/fuel_cartridge))
		var/obj/item/weapon/fuel_cartridge/tank = W
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

/obj/item/weapon/weldpack/examine(mob/user)
	. = ..(user)
	to_chat(user, text("\icon[] [] units of fuel left!", src, src.reagents.total_volume))
	return
