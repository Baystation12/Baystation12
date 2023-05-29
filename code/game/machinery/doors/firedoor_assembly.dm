/obj/structure/firedoor_assembly
	name = "emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/hazard/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	opacity = 0
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/wired = 0


/obj/structure/firedoor_assembly/use_tool(obj/item/tool, mob/user, list/click_params)
	// Air Alarm Electronics - Install circuit
	if (istype(tool, /obj/item/airalarm_electronics))
		if (!wired)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install \the [tool].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		var/obj/machinery/door/firedoor/new_door = new(loc)
		new_door.hatch_open = TRUE
		new_door.close()
		transfer_fingerprints_to(new_door)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		qdel(tool)
		qdel_self()
		return TRUE

	// Cable Coil - Wire the assembly
	if (isCoil(tool))
		if (wired)
			USE_FEEDBACK_FAILURE("\The [src] is already wired.")
			return TRUE
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be anchored before you can wire it.")
			return TRUE
		var/obj/item/stack/cable_coil/cable = tool
		if (!cable.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 1, "to wire \the [src].")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts wiring \the [src] with [cable.get_vague_name(FALSE)]."),
			SPAN_NOTICE("You start wiring \the [src] with [cable.get_exact_name(1)].")
		)
		if (!user.do_skilled(4 SECONDS, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (wired)
			USE_FEEDBACK_FAILURE("\The [src] is already wired.")
			return TRUE
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be anchored before you can wire it.")
			return TRUE
		if (!cable.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 1, "to wire \the [src].")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \the [src] with [cable.get_vague_name(FALSE)]."),
			SPAN_NOTICE("You wire \the [src] with [cable.get_exact_name(1)].")
		)
		return TRUE

	// Welding Tool - Disassemble
	if (isWelder(tool))
		if (anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be unanchored before you can dismantle it.")
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(1, user, "to dismantle \the [src]."))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts dismantling \the [src] with \a [tool]."),
			SPAN_NOTICE("You start dismantling \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		var/obj/item/stack/material/steel/stack = new (loc, 4)
		transfer_fingerprints_to(stack)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel_self()
		return TRUE

	// Wirecutters - Cut wires
	if (isWirecutter(tool))
		if (!wired)
			USE_FEEDBACK_FAILURE("\The [src] has no wires to cut.")
			return TRUE
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts cutting \the [src]'s wires with \a [tool]."),
			SPAN_NOTICE("You start cutting \the [src]'s wires with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!wired)
			USE_FEEDBACK_FAILURE("\The [src] has no wires to cut.")
			return TRUE
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		new /obj/item/stack/cable_coil(loc, 1)
		wired = FALSE
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \the [src]'s wires with \a [tool]."),
			SPAN_NOTICE("You cut \the [src]'s wires with \the [tool].")
		)
		return TRUE

	return ..()
