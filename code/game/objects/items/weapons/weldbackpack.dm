//Welder backpack:
//A small backpack that can refuel welding tools and cartridges on the fly.
//Can be refilled on stationary welding tanks.

/obj/item/storage/backpack/weldpack
	name = "welding tank backpack"
	desc = "A small, uncomfortable backpack, fitted with a massive fuel tank on the side. It has a refueling port for most models of portable welding tools and cartridges."
	icon_state = "welderpack"
	item_state_slots = list(slot_l_hand_str = "welderpack", slot_r_hand_str = "welderpack")
	max_storage_space = ITEM_SIZE_NORMAL * 7
	var/max_fuel = 350
	var/obj/item/weldingtool/welder

/obj/item/storage/backpack/weldpack/Initialize()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)

	. = ..()

/obj/item/storage/backpack/weldpack/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isWelder(W))
		var/obj/item/weldingtool/T = W
		if (!T.tank)
			to_chat(user, SPAN_WARNING("\The [T] has no tank attached!"))
			return TRUE
		if (!T.tank.can_refuel)
			to_chat(user, SPAN_WARNING("\The [T]'s [T.tank.name] does not have a refuelling port."))
			return TRUE
		if (T.welding)
			if (user.a_intent == I_HURT)
				user.visible_message(
					SPAN_DANGER("\The [user] holds \a [T] up to \a [src], causing an explosion!"),
					SPAN_DANGER("You hold \the [T] up to \the [src], causing an explosion!")
				)
				log_and_message_admins("triggered a fueltank explosion.", user)
				explosion(get_turf(src), 4, EX_ACT_HEAVY)
				if (!QDELETED(src))
					qdel(src)
				return TRUE
			else
				to_chat(user, SPAN_WARNING("You need to turn \the [T] off before you can refuel it. Or use harm intent if you're suicidal."))
				return TRUE
		if (!reagents.trans_to_obj(T.tank, T.tank.max_fuel))
			to_chat(user, SPAN_WARNING("\The [T]'s [T.tank.name] is already full."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You refill \the [T] with \the [src]."))
		playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
		return TRUE

	else if(istype(W, /obj/item/welder_tank))
		var/obj/item/welder_tank/tank = W
		if (!tank.can_refuel)
			to_chat(user, SPAN_WARNING("\The [tank] does not have a refuelling port."))
			return TRUE
		if (!reagents.trans_to_obj(tank, tank.max_fuel))
			to_chat(user, SPAN_WARNING("\The [tank] is already full."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You refuel \the [tank] with \the [src]."))
		playsound(loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return TRUE

	else return ..()

/obj/item/storage/backpack/weldpack/use_after(obj/O, mob/living/user, click_parameters)
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You crack the cap off the top of \the [src] and fill it back up again from the tank."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return TRUE
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_WARNING("The pack is already full!"))
		return TRUE

/obj/item/storage/backpack/weldpack/examine(mob/user)
	. = ..()
	to_chat(user, text("[icon2html(src, user)] [] units of fuel left!", src.reagents.total_volume))
