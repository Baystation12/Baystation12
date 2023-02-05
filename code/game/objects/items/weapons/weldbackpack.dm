//Welder backpack:
//A small backpack that can refuel welding tools and cartridges on the fly.
//Can be refilled on stationary welding tanks.

/obj/item/storage/backpack/weldpack
	name = "welding tank backpack"
	desc = "A small, uncomfortable backpack, fitted with a massive fuel tank on the side. It has a refueling port for most models of portable welding tools and cartridges."
	icon_state = "welderpack"
	item_state_slots = list(slot_l_hand_str = "welderpack", slot_r_hand_str = "welderpack")
	max_storage_space = 20
	var/max_fuel = 350
	var/obj/item/weldingtool/welder

/obj/item/storage/backpack/weldpack/Initialize()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)

	. = ..()


/obj/item/storage/backpack/weldpack/get_interactions_info()
	. = ..()
	.["Welding Fuel Tank"] = "<p>Refills the fuel tank.</p>"
	.[CODEX_INTERACTION_WELDER] = {"
		<p>Refills the welder's fuel tank. The welder must have a tank inserted and must be turned off.</p>
		<p>On harm intent, if the welder is turned on, causes the welding pack to explode.</p>
	"}


/obj/item/storage/backpack/weldpack/use_weapon(obj/item/weapon, mob/user, list/click_params)
	// Welding Tool - Detonate weldpack
	if (isWelder(weapon))
		var/obj/item/weldingtool/welder = weapon
		if (!welder.welding)
			to_chat(user, SPAN_WARNING("\The [weapon] must be turned on to ignite \the [src]. Or use harm intent if you want to refuel it."))
			return TRUE
		welder.burn_fuel(1)
		user.visible_message(
			SPAN_DANGER("\The [user] holds \a [weapon] up to \the [src], causing an explosion!"),
			SPAN_DANGER("You hold \the [weapon] up to \the [src], causing an explosion!")
		)
		log_and_message_admins("triggered a fueltank explosion.", user)
		explosion(get_turf(src), 4, EX_ACT_HEAVY)
		if (!QDELETED(src))
			qdel(src)
		return TRUE

	return ..()


/obj/item/storage/backpack/weldpack/use_tool(obj/item/tool, mob/user, list/click_params)
	// Welding Tank - Refill tank
	if (istype(tool, /obj/item/welder_tank))
		var/obj/item/welder_tank/tank = tool
		var/tool_name = isWelder(tank.loc) ? "[tank.loc.name]'s [name]" : name
		if (!tank.can_refuel)
			to_chat(user, SPAN_WARNING("\The [tool_name] does not have a refuelling port."))
			return TRUE
		if (!reagents.trans_to_obj(tool, tank.max_fuel))
			to_chat(user, SPAN_WARNING("\The [tool_name] is already full."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] refuels \a [tool_name] with \the [src]."),
			SPAN_NOTICE("You refuel \the [tool_name] with \the [src]."),
			range = 2
		)
		playsound(src, 'sound/effects/refill.ogg', 50, TRUE, -6)
		return TRUE

	// Welding Tool - Refill tank (Proxies to welding tank)
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.tank)
			to_chat(user, SPAN_WARNING("\The [tool] has no tank attached to refill."))
			return TRUE
		if (welder.welding)
			to_chat(user, SPAN_WARNING("You need to turn \the [tool] off before you can refuel it. Or use harm intent if you're suicidal."))
			return TRUE
		return use_tool(welder.tank, user, click_params)

	return ..()


/obj/item/storage/backpack/weldpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You crack the cap off the top of \the [src] and fill it back up again from the tank."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, SPAN_WARNING("The pack is already full!"))
		return

/obj/item/storage/backpack/weldpack/examine(mob/user)
	. = ..()
	to_chat(user, text("[icon2html(src, user)] [] units of fuel left!", src.reagents.total_volume))
