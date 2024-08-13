
/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/structures/liquid_tanks.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE

	var/initial_capacity = 1000
	var/initial_reagent_types  // A list of reagents and their ratio relative the initial capacity. list(/datum/reagent/water = 0.5) would fill the dispenser halfway to capacity.
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = "10;25;50;100;500"

/obj/structure/reagent_dispensers/New()
	create_reagents(initial_capacity)

	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this

	for(var/reagent_type in initial_reagent_types)
		var/reagent_ratio = initial_reagent_types[reagent_type]
		reagents.add_reagent(reagent_type, reagent_ratio * initial_capacity)

	..()

/obj/structure/reagent_dispensers/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	to_chat(user, SPAN_NOTICE("It contains:"))
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/R in reagents.reagent_list)
			to_chat(user, SPAN_NOTICE("[R.volume] units of [R.name]"))
	else
		to_chat(user, SPAN_NOTICE("Nothing."))

/obj/structure/reagent_dispensers/verb/set_amount_per_transfer_from_this()
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_number_list_decode(possible_transfer_amounts)
	if(!CanPhysicallyInteract(usr))  // because input takes time and the situation can change
		to_chat(usr, SPAN_NOTICE("You're in no condition to do that!'"))
		return
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			if (prob(50))
				new /obj/effect/water(src.loc)
				qdel(src)
				return
		if(EX_ACT_LIGHT)
			if (prob(5))
				new /obj/effect/water(src.loc)
				qdel(src)
				return
		else
	return

/obj/structure/reagent_dispensers/AltClick(mob/user)
	if(possible_transfer_amounts)
		set_amount_per_transfer_from_this()
		return TRUE
	return ..()


//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A tank containing water."
	icon = 'icons/obj/structures/liquid_tanks.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/fill_level = FLUID_SHALLOW // Can be adminbussed for silly room-filling tanks.
	possible_transfer_amounts = "10;25;50;100"
	initial_capacity = 50000
	initial_reagent_types = list(/datum/reagent/water = 1)
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/watertank/proc/drain_water()
	if(reagents.total_volume <= 0)
		return

	// To prevent it from draining while in a container.
	if(!isturf(src.loc))
		return

	// Check for depth first, and pass if the water's too high. A four foot high water tank
	// cannot jettison water above the level of a grown adult's head!
	var/turf/T = get_turf(src)

	if(!T || T.get_fluid_depth() > fill_level)
		return

	// For now, this cheats and only checks/leaks water, pending additions to the fluid system.
	var/W = reagents.remove_reagent(/datum/reagent/water, amount_per_transfer_from_this * 5)
	if(W > 0)
		// Artificially increased flow - a 1:1 rate doesn't result in very much water at all.
		T.add_fluid(W * 100, /datum/reagent/water)

/obj/structure/reagent_dispensers/watertank/examine(mob/user)
	. = ..()

	if(modded)
		to_chat(user, SPAN_WARNING("Someone has wrenched open its tap - it's spilling everywhere!"))


/obj/structure/reagent_dispensers/watertank/use_tool(obj/item/tool, mob/user, list/click_params)
	// Robot Arm - Attach arm for farmbot
	if (is_type_in_list(tool, list(/obj/item/robot_parts/l_arm, /obj/item/robot_parts/r_arm)))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		var/obj/item/farmbot_arm_assembly/new_assembly = new /obj/item/farmbot_arm_assembly(loc, src)
		transfer_fingerprints_to(new_assembly)
		tool.transfer_fingerprints_to(new_assembly)
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \the [src]."),
			SPAN_NOTICE("You attach \a [tool] to \the [src].")
		)
		qdel(tool)
		return TRUE

	// Wrench - Toggle valve
	if (isWrench(tool))
		modded = !modded
		user.visible_message(
			SPAN_NOTICE("\The [user] [modded ? "opens" : "closes"] \the [src]'s valve with \a [tool]."),
			SPAN_NOTICE("You [user] [modded ? "open" : "close"] \the [src]'s valve with \the [tool].")
		)
		if (modded)
			log_and_message_admins("opened a water tank at [get_area(src)], leaking water", user, get_turf(src))
			START_PROCESSING(SSprocessing, src)
		else
			STOP_PROCESSING(SSprocessing, src)
		return TRUE

	return ..()


/obj/structure/reagent_dispensers/watertank/Process()
	if(modded)
		drain_water()

/obj/structure/reagent_dispensers/watertank/Destroy()
	. = ..()

	STOP_PROCESSING(SSprocessing, src)

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank containing welding fuel."
	icon = 'icons/obj/structures/liquid_tanks.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null
	initial_reagent_types = list(/datum/reagent/fuel = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	. = ..()

	if (modded)
		to_chat(user, SPAN_WARNING("The faucet is wrenched open, leaking fuel!"))
	if(rig)
		to_chat(user, SPAN_NOTICE("There is some kind of device rigged to the tank."))

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if (rig)
		usr.visible_message(SPAN_NOTICE("\The [usr] begins to detach \the [rig] from \the [src]."), SPAN_NOTICE("You begin to detach \the [rig] from \the [src]."))
		if(do_after(usr, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			usr.visible_message(SPAN_NOTICE("\The [usr] detaches \the [rig] from \the [src]."), SPAN_NOTICE("You detach [rig] from \the [src]"))
			rig.dropInto(usr.loc)
			rig = null
			ClearOverlays()


/obj/structure/reagent_dispensers/fueltank/use_weapon(obj/item/weapon, mob/user, list/click_params)
	// Flame Source - Kaboom
	if (IsFlameSource(weapon))
		user.visible_message(
			SPAN_WARNING("\The [user] holds \a [weapon] up against \the [src], heating it up!"),
			SPAN_WARNING("You hold \the [weapon] up against \the [src], heating it up!")
		)
		if (!do_after(user, 5 SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT) || !user.use_sanity_check(src, weapon))
			return TRUE
		if (!IsFlameSource(weapon))
			USE_FEEDBACK_FAILURE("\The [weapon] isn't hot enough anymore.")
			return TRUE
		log_and_message_admins("triggered a fuel tank explosion with \the [weapon] in [get_area(src)]", user, get_turf(src))
		user.visible_message(
			SPAN_DANGER("\The [user] holds \a [weapon] against \the [src], causing it to explode!"),
			SPAN_DANGER("You hold \the [weapon] against \the [src], causing it to explode!")
		)
		explode()
		return TRUE

	return ..()


/obj/structure/reagent_dispensers/fueltank/use_tool(obj/item/tool, mob/user, list/click_params)
	// Assembly Holder - Attach assembly
	if (istype(tool, /obj/item/device/assembly_holder))
		if (rig)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [rig] attached.")
			return TRUE
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts attaching \a [tool] to \the [src]."),
			SPAN_NOTICE("You start attaching \the [tool] to \the [src].")
		)
		if (!user.do_skilled(2 SECONDS, SKILL_DEVICES, src) || !user.use_sanity_check(src, tool, SANITY_CHECK_DEFAULT | SANITY_CHECK_TOOL_UNEQUIP))
			return TRUE
		if (rig)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [rig] attached.")
			return TRUE
		user.unEquip(tool, src)
		rig = tool
		if (istype(rig.a_left, /obj/item/device/assembly/igniter) || istype(rig.a_right, /obj/item/device/assembly/igniter))
			log_and_message_admins("rigged a fuel tank for explosion at [get_area(src)].", user, get_turf(src))
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [tool] to \the [src]."),
			SPAN_NOTICE("You attach \the [tool] to \the [src].")
		)
		return TRUE

	// Flame Source - Warn against kaboom
	if (IsFlameSource(tool))
		USE_FEEDBACK_FAILURE("You refrain from heating up \the [src] with \the [tool].")
		return TRUE

	// Wrench - Toggle valve
	if (isWrench(tool))
		modded = !modded
		user.visible_message(
			SPAN_NOTICE("\The [user] [modded ? "opens" : "closes"] \the [src]'s valve with \a [tool]."),
			SPAN_NOTICE("You [user] [modded ? "open" : "close"] \the [src]'s valve with \the [tool].")
		)
		if (modded)
			log_and_message_admins("opened a fuel tank at [get_area(src)], leaking fuel.", user, src)
			leak_fuel(amount_per_transfer_from_this)
		return TRUE

	return ..()


/obj/structure/reagent_dispensers/fueltank/on_update_icon()
	ClearOverlays()
	if (rig)
		var/icon/rig_overlay = getFlatIcon(rig)
		rig_overlay.Shift(NORTH, 1)
		rig_overlay.Shift(EAST, 6)
		AddOverlays(rig_overlay)


/obj/structure/reagent_dispensers/fueltank/bullet_act(obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			var/turf/turf = get_turf(src)
			if(turf)
				var/area/area = turf.loc || "*unknown area*"
				log_and_message_admins("shot a fuel tank in \the [area].", Proj.firer, loc)
			else
				log_and_message_admins("shot a fuel tank outside the world.", Proj.firer, loc)

		if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/proc/explode()
	for(var/datum/reagent/R in reagents.reagent_list)
		R.ex_act(src, 1)
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (modded)
		explode()
	else if (exposed_temperature > T0C+500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	if (..() && modded)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (QDELING(src) || reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(/datum/reagent/fuel,amount)
	new /obj/decal/cleanable/liquid_fuel(src.loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Refills pepper spray canisters."
	icon = 'icons/obj/structures/chemical_dispensers.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 45
	initial_reagent_types = list(/datum/reagent/capsaicin/condensed = 1)


/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A machine that dispenses cool water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	initial_capacity = 500
	initial_reagent_types = list(/datum/reagent/water = 1)
	var/cups = 12
	var/cup_type = /obj/item/reagent_containers/food/drinks/sillycup

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/user)
	if(cups > 0)
		var/visible_messages = DispenserMessages(user)
		visible_message(visible_messages[1], visible_messages[2])
		var/cup = new cup_type(loc)
		user.put_in_active_hand(cup)
		cups--
	else
		to_chat(user, RejectionMessage(user))

/obj/structure/reagent_dispensers/water_cooler/proc/DispenserMessages(mob/user)
	return list("\The [user] grabs a paper cup from \the [src].", "You grab a paper cup from \the [src]'s cup compartment.")

/obj/structure/reagent_dispensers/water_cooler/proc/RejectionMessage(mob/user)
	return "The [src]'s cup dispenser is empty."


/obj/structure/reagent_dispensers/water_cooler/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	if (interaction_handled)
		flick("[icon_state]-vend", src)
	..()


/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/structures/liquid_tanks.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	initial_reagent_types = list(/datum/reagent/ethanol/beer = 1)
	atom_flags = ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_CAN_TABLE

/obj/structure/reagent_dispensers/acid
	name = "sulphuric acid dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/structures/chemical_dispensers.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	initial_reagent_types = list(/datum/reagent/acid = 1)
