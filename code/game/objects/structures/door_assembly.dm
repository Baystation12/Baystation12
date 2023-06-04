/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	density = TRUE
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/const/ASSEMBLY_STATE_FRAME = 0
	var/const/ASSEMBLY_STATE_WIRED = 1
	var/const/ASSEMBLY_STATE_CIRCUIT = 2
	var/state = ASSEMBLY_STATE_FRAME

	var/static/list/reinforcement_materials = list(
		MATERIAL_GOLD,
		MATERIAL_SILVER,
		MATERIAL_DIAMOND,
		MATERIAL_URANIUM,
		MATERIAL_PHORON,
		MATERIAL_SANDSTONE
	)

	var/base_icon_state = ""
	var/base_name = "Airlock"
	var/obj/item/airlock_electronics/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/glass_type = /obj/machinery/door/airlock/glass
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null
	var/panel_icon = 'icons/obj/doors/station/panel.dmi'
	var/fill_icon = 'icons/obj/doors/station/fill_steel.dmi'
	var/glass_icon = 'icons/obj/doors/station/fill_glass.dmi'
	var/paintable = AIRLOCK_PAINTABLE_MAIN|AIRLOCK_PAINTABLE_STRIPE
	var/door_color = "none"
	var/stripe_color = "none"
	var/symbol_color = "none"


/obj/structure/door_assembly/Initialize()
	. = ..()
	update_state()


/obj/structure/door_assembly/door_assembly_hatch
	icon = 'icons/obj/doors/hatch/door.dmi'
	panel_icon = 'icons/obj/doors/hatch/panel.dmi'
	fill_icon = 'icons/obj/doors/hatch/fill_steel.dmi'
	base_name = "Airtight Hatch"
	airlock_type = /obj/machinery/door/airlock/hatch
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_icon = 'icons/obj/doors/secure/fill_steel.dmi'
	base_name = "High Security Airlock"
	airlock_type = /obj/machinery/door/airlock/highsecurity
	glass = -1
	paintable = 0

/obj/structure/door_assembly/door_assembly_ext
	icon = 'icons/obj/doors/external/door.dmi'
	fill_icon = 'icons/obj/doors/external/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/external/fill_glass.dmi'
	base_name = "External Airlock"
	airlock_type = /obj/machinery/door/airlock/external
	glass_type = /obj/machinery/door/airlock/external/glass
	paintable = 0

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/double/door.dmi'
	fill_icon = 'icons/obj/doors/double/fill_steel.dmi'
	glass_icon = 'icons/obj/doors/double/fill_glass.dmi'
	panel_icon = 'icons/obj/doors/double/panel.dmi'
	dir = EAST
	var/width = 1
	airlock_type = /obj/machinery/door/airlock/multi_tile
	glass_type = /obj/machinery/door/airlock/multi_tile/glass


/obj/structure/door_assembly/multi_tile/Initialize()
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size
	update_state()


/obj/structure/door_assembly/multi_tile/Move()
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size


/obj/structure/door_assembly/can_anchor(obj/item/tool, mob/user, silent)
	. = ..()
	if (!.)
		return
	if (state != ASSEMBLY_STATE_FRAME)
		if (!silent)
			USE_FEEDBACK_FAILURE("\The [src] needs its components and wiring removed before you can unanchor it.")
		return FALSE


/obj/structure/door_assembly/use_tool(obj/item/tool, mob/user, list/click_params)
	// Airlock Electronics - Install circuit
	if (istype(tool, /obj/item/airlock_electronics))
		if (state < ASSEMBLY_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install \the [src].")
			return TRUE
		if (electronics)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [electronics] installed.")
			return TRUE
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts installing \a [tool] into \the [src]."),
			SPAN_NOTICE("You start installing \the [tool] into \the [src].")
		)
		if (!user.do_skilled(4 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state < ASSEMBLY_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install \the [src].")
			return TRUE
		if (electronics)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [electronics] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		state = ASSEMBLY_STATE_CIRCUIT
		electronics = tool
		update_state()
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE

	// Cable Coil - Add wiring
	if (isCoil(tool))
		if (state != ASSEMBLY_STATE_FRAME)
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
			SPAN_NOTICE("\The [user] starts wiring \the [src] with \a [tool]."),
			SPAN_NOTICE("You start wiring \the [src] with \the [tool].")
		)
		if (!user.do_skilled(4 SECONDS, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state != ASSEMBLY_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src] is already wired.")
			return TRUE
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be anchored before you can wire it.")
			return TRUE
		if (!cable.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 1, "to wire \the [src].")
			return TRUE
		state = ASSEMBLY_STATE_WIRED
		update_state()
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \the [src] with \a [tool]."),
			SPAN_NOTICE("You wire \the [src] with \the [tool].")
		)
		return TRUE

	// Crowbar - Remove circuit
	if (isCrowbar(tool))
		if (!electronics)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts removing \the [src]'s [electronics.name] with \a [tool]."),
			SPAN_NOTICE("You start removing \the [src]'s [electronics.name] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!electronics)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		electronics.dropInto(loc)
		electronics.add_fingerprint(user)
		electronics = null
		state = ASSEMBLY_STATE_WIRED
		update_state()
		playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [src]'s [electronics.name] with \a [tool]."),
			SPAN_NOTICE("You remove \the [src]'s [electronics.name] with \the [tool].")
		)
		return TRUE

	// Material Stack - Add glass/plating
	if (istype(tool, /obj/item/stack/material))
		if (glass)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [istext(glass) ? "[glass] plating" : "glass panel"] installed.")
			return TRUE
		var/obj/item/stack/material/stack = tool
		var/material_name = stack.get_material_name()
		// Glass Panel
		if (material_name == MATERIAL_GLASS)
			if (!stack.reinf_material)
				USE_FEEDBACK_FAILURE("\The [src] needs reinforced glass to make a glass panel.")
				return TRUE
			if (!stack.can_use(1))
				USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to make a glass panel.")
				return TRUE
			playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] starts installing a glass panel into \the [src]."),
				SPAN_NOTICE("You start installing a glass panel into \the [src].")
			)
			if (!user.do_skilled(4 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
				return TRUE
			if (glass)
				USE_FEEDBACK_FAILURE("\The [src] already has \a [istext(glass) ? "[glass] plating" : "glass panel"] installed.")
				return TRUE
			if (!stack.reinf_material)
				USE_FEEDBACK_FAILURE("\The [src] needs reinforced glass to make a glass panel.")
				return TRUE
			if (!stack.use(1))
				USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to make a glass panel.")
				return TRUE
			glass = TRUE
			update_state()
			playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] starts installing a glass panel into \the [src]."),
				SPAN_NOTICE("You start installing a glass panel into \the [src].")
			)
			return TRUE
		// Plating
		if (material_name in reinforcement_materials)
			if (!stack.can_use(2))
				USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 2, "to reinforce \the [src].")
				return TRUE
			playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] starts installing \a [material_name] plating into \the [src]."),
				SPAN_NOTICE("You start installing \a [material_name] plating into \the [src].")
			)
			if (!user.do_skilled(4 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
				return TRUE
			if (glass)
				USE_FEEDBACK_FAILURE("\The [src] already has \a [istext(glass) ? "[glass] plating" : "glass panel"] installed.")
				return TRUE
			if (!stack.use(2))
				USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 2, "to reinforce \the [src].")
				return TRUE
			glass = material_name
			update_state()
			playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] installs \a [material_name] plating into \the [src]."),
				SPAN_NOTICE("You install \a [material_name] plating into \the [src].")
			)
			return TRUE
		USE_FEEDBACK_FAILURE("\The [src] can't be reinforced with [material_name].")
		return TRUE

	// Pen - Name door
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "Enter the name for the door", "[src] - Name", created_name) as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!input || input == created_name || !user.use_sanity_check(src, tool))
			return TRUE
		created_name = input
		update_state()
		user.visible_message(
			SPAN_NOTICE("\The [user] names \the [src] to '[created_name]' with \a [tool]."),
			SPAN_NOTICE("You name \the [src] to '[created_name]' with \the [tool].")
		)
		return TRUE

	// Screwdriver - Finish airlock
	if (isScrewdriver(tool))
		if (state != ASSEMBLY_STATE_CIRCUIT)
			USE_FEEDBACK_FAILURE("\The [src] needs a circuit before you can finish it.")
			return TRUE
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts finishing \the [src] with \a [tool]."),
			SPAN_NOTICE("You start finishing \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state != ASSEMBLY_STATE_CIRCUIT)
			USE_FEEDBACK_FAILURE("\The [src] needs a circuit before you can finish it.")
			return TRUE
		var/path
		if(istext(glass))
			path = text2path("/obj/machinery/door/airlock/[glass]")
		else if (glass == 1)
			path = glass_type
		else
			path = airlock_type
		var/obj/machinery/door/airlock/airlock = new path(loc, src)
		transfer_fingerprints_to(airlock)
		airlock.add_fingerprint(user, tool = tool)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] finishes \the [airlock] with \a [tool]."),
			SPAN_NOTICE("You finishes \the [airlock] with \the [tool].")
		)
		qdel_self()
		return TRUE

	// Welder
	// - Remove glass
	// - Dismantle assembly
	if (isWelder(tool))
		// Remove glass/plating
		if (glass)
			var/glass_noun = istext(glass) ? "[glass] plating" : "glass panel"
			var/obj/item/weldingtool/welder = tool
			if (!welder.can_use(1, user, "to remove \the [src]'s [glass_noun]."))
				return TRUE
			playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] starts welding \the [src]'s [glass_noun] off with \a [tool]."),
				SPAN_NOTICE("You start welding \the [src]'s [glass_noun] off with \the [tool].")
			)
			if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
				return TRUE
			if (!glass)
				USE_FEEDBACK_FAILURE("\The [src]'s state has changed.")
				return TRUE
			if (!welder.remove_fuel(1, user))
				return TRUE
			var/obj/item/stack/material/stack
			if (istext(glass))
				var/path = text2path("/obj/item/stack/material/[glass]")
				stack = new path(loc, 2)
			else
				stack = new /obj/item/stack/material/glass/reinforced(loc)
			stack.add_fingerprint(user, tool = tool)
			glass = null
			update_state()
			playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
			user.visible_message(
				SPAN_NOTICE("\The [user] welds \the [src]'s [glass_noun] off with \a [tool]."),
				SPAN_NOTICE("You weld \the [src]'s [glass_noun] off with \the [tool].")
			)
			return TRUE
		// Dismantle assembly
		if (anchored)
			USE_FEEDBACK_FAILURE("\The [src] must be unanchored before you can dismantle it.")
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(1, user, "to dismantle \the [src]."))
			return TRUE
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts dismantling \the [src] with \a [tool]."),
			SPAN_NOTICE("You start dismantling \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (anchored)
			USE_FEEDBACK_FAILURE("\The [src] must be unanchored before you can dismantle it.")
			return TRUE
		if (!welder.remove_fuel(1, user))
			return TRUE
		var/obj/item/stack/material/steel/stack = new(loc, 4)
		transfer_fingerprints_to(stack)
		stack.add_fingerprint(user, tool = tool)
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel_self()
		return TRUE

	// Wirecutter - Remove wires
	if (isWirecutter(tool))
		if (state < ASSEMBLY_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (state > ASSEMBLY_STATE_WIRED)
			// TODO: Feedback message
			return TRUE
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts cutting \the [src]'s wires with \a [tool]."),
			SPAN_NOTICE("You start cutting \the [src]'s wires with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state < ASSEMBLY_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (state > ASSEMBLY_STATE_WIRED)
			// TODO: Feedback message
			return TRUE
		var/obj/item/stack/cable_coil/cable = new(loc, 1)
		cable.add_fingerprint(user, tool = tool)
		state = ASSEMBLY_STATE_FRAME
		update_state()
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \the [src]'s wires with \a [tool]."),
			SPAN_NOTICE("You cut \the [src]'s wires with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/door_assembly/proc/update_state()
	overlays.Cut()
	var/image/filling_overlay
	var/image/panel_overlay
	var/final_name = ""
	if(glass == 1)
		filling_overlay = image(glass_icon, "construction")
	else
		filling_overlay = image(fill_icon, "construction")
	switch (state)
		if(0)
			if (anchored)
				final_name = "Secured "
		if(1)
			final_name = "Wired "
			panel_overlay = image(panel_icon, "construction0")
		if(2)
			final_name = "Near Finished "
			panel_overlay = image(panel_icon, "construction1")
	final_name += "[glass == 1 ? "Window " : ""][istext(glass) ? "[glass] Airlock" : base_name] Assembly"
	SetName(final_name)
	overlays += filling_overlay
	overlays += panel_overlay
