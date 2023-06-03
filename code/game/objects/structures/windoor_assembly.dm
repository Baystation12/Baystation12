/* Windoor (window door) assembly -Nodrak
 * Step 1: Create a windoor out of rglass
 * Step 2: Add r-glass to the assembly to make a secure windoor (Optional)
 * Step 3: Rotate or Flip the assembly to face and open the way you want
 * Step 4: Wrench the assembly in place
 * Step 5: Add cables to the assembly
 * Step 6: Set access for the door.
 * Step 7: Crowbar the door to complete
 */


/obj/structure/windoor_assembly
	name = "windoor assembly"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "l_windoor_assembly01"
	anchored = FALSE
	density = FALSE
	dir = NORTH
	w_class = ITEM_SIZE_NORMAL
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/obj/item/airlock_electronics/electronics = null

	//Vars to help with the icon's name
	var/facing = "l"	//Does the windoor open to the left or right?
	var/secure = ""		//Whether or not this creates a secure windoor

	var/const/WINDOOR_STATE_FRAME = "01"
	var/const/WINDOOR_STATE_WIRED = "02"
	/// String (One of `WINDOOR_STATE_*`). How far the door assembly has progressed in terms of sprites
	var/state = WINDOOR_STATE_FRAME

/obj/structure/windoor_assembly/New(Loc, start_dir=NORTH, constructed=0)
	..()
	if(constructed)
		state = WINDOOR_STATE_FRAME
		anchored = FALSE
	switch(start_dir)
		if(NORTH, SOUTH, EAST, WEST)
			set_dir(start_dir)
		else //If the user is facing northeast. northwest, southeast, southwest or north, default to north
			set_dir(NORTH)

	update_nearby_tiles(need_rebuild=1)

/obj/structure/windoor_assembly/Destroy()
	set_density(0)
	update_nearby_tiles()
	..()

/obj/structure/windoor_assembly/on_update_icon()
	icon_state = "[facing]_[secure]windoor_assembly[state]"

/obj/structure/windoor_assembly/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/windoor_assembly/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1


/obj/structure/windoor_assembly/can_anchor(obj/item/tool, mob/user, silent)
	. = ..()
	if (!.)
		return
	if (state != WINDOOR_STATE_FRAME)
		if (!silent)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring must be removed before you can unanchor it.")
		return FALSE


/obj/structure/windoor_assembly/use_tool(obj/item/tool, mob/user, list/click_params)
	// Airlock electronics - Install electronics
	if (istype(tool, /obj/item/airlock_electronics))
		if (state != WINDOOR_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install \the [tool].")
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
		if (state != WINDOOR_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] needs to be wired before you can install \the [tool].")
			return TRUE
		if (electronics)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [electronics] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		electronics = tool
		update_icon()
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE

	// Cable Coil - Wire assembly
	if (istype(tool, /obj/item/stack/cable_coil))
		if (state != WINDOOR_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src] is already wired.")
			return TRUE
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] must be anchored before you can wire it.")
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
		if (state != WINDOOR_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src] is already wired.")
			return TRUE
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] must be anchored before you can wire it.")
			return TRUE
		if (!cable.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(cable, 1, "to wire \the [src].")
			return TRUE
		state = WINDOOR_STATE_WIRED
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] wires \the [src] with \a [tool]."),
			SPAN_NOTICE("You wires \the [src] with \the [tool].")
		)
		return TRUE

	// Rods - Make assembly secure
	if (istype(tool, /obj/item/stack/material/rods))
		if (state != WINDOOR_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring must be removed before you can reinforce it.")
			return TRUE
		if (secure)
			USE_FEEDBACK_FAILURE("\The [src] already has reinforcements installed.")
			return TRUE
		var/obj/item/stack/material/rods/rods = tool
		if (!rods.can_use(4))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 4, "to reinforce \the [src].")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts reinforcing \the [src] with some [tool.name]."),
			SPAN_NOTICE("You start reinforcing \the [src] with some [tool.name].")
		)
		if (!user.do_skilled(4 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state != WINDOOR_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring must be removed before you can reinforce it.")
			return TRUE
		if (secure)
			USE_FEEDBACK_FAILURE("\The [src] already has reinforcements installed.")
			return TRUE
		if (!rods.use(4))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 4, "to reinforce \the [src].")
			return TRUE
		secure = "secure_"
		SetName("secure [initial(name)]")
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] reinforces \the [src] with some [tool.name]."),
			SPAN_NOTICE("You reinforce \the [src] with some [tool.name].")
		)
		return TRUE

	// Screwdriver - Remove electronics
	if (isScrewdriver(tool))
		if (!electronics)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts removing \the [src]'s circuits with \a [tool]."),
			SPAN_NOTICE("You start removing \the [src]'s circuits with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!electronics)
			USE_FEEDBACK_FAILURE("\The [src] has no circuit to remove.")
			return TRUE
		electronics.dropInto(loc)
		electronics.add_fingerprint(user, tool = tool)
		electronics = null
		update_icon()
		playsound(src, 'sound/items/Screwdriver.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts removing \the [src]'s circuits with \a [tool]."),
			SPAN_NOTICE("You start removing \the [src]'s circuits with \the [tool].")
		)
		return TRUE

	// Wirecutter - Remove wiring
	if (isWirecutter(tool))
		if (state != WINDOOR_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (electronics)
			USE_FEEDBACK_FAILURE("\The [src]'s electronics need to be removed before you can cut the wiring.")
			return TRUE
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts cutting \the [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You start cutting \the [src]'s wiring with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_ELECTRICAL, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (state != WINDOOR_STATE_WIRED)
			USE_FEEDBACK_FAILURE("\The [src] has no wiring to remove.")
			return TRUE
		if (electronics)
			USE_FEEDBACK_FAILURE("\The [src]'s electronics need to be removed before you can cut the wiring.")
			return TRUE
		var/obj/item/stack/cable_coil/cable = new (loc, 1)
		cable.add_fingerprint(user, tool = tool)
		state = WINDOOR_STATE_FRAME
		update_icon()
		playsound(src, 'sound/items/Wirecutter.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] cuts \the [src]'s wiring with \a [tool]."),
			SPAN_NOTICE("You cut \the [src]'s wiring with \the [tool].")
		)
		return TRUE

	// Welder - Dismantle
	if (isWelder(tool))
		if (state != WINDOOR_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring must be removed before you can dismantle it.")
			return TRUE
		if (anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be unanchored before you can dismantle it.")
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
		if (state != WINDOOR_STATE_FRAME)
			USE_FEEDBACK_FAILURE("\The [src]'s wiring must be removed before you can dismantle it.")
			return TRUE
		if (anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be unanchored before you can dismantle it.")
			return TRUE
		if (!welder.remove_fuel(1, user))
			return TRUE
		var/obj/item/stack/material/glass/reinforced/glass = new(loc, 5)
		transfer_fingerprints_to(glass)
		if (secure)
			var/obj/item/stack/material/rods/rods = new(loc, 4)
			transfer_fingerprints_to(rods)
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		qdel_self()
		return TRUE

	// Crowbar - Complete assembly
	if (isCrowbar(tool))
		if (!electronics)
			USE_FEEDBACK_FAILURE("\The [src] needs a circuit board before you can complete it.")
			return TRUE
		playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts prying \the [src] into its frame with \a [tool]."),
			SPAN_NOTICE("You start prying \the [src] into its frame with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!electronics)
			USE_FEEDBACK_FAILURE("\The [src] needs a circuit board before you can complete it.")
			return TRUE
		var/obj/machinery/door/window/windoor
		if (secure)
			windoor = new /obj/machinery/door/window/brigdoor(loc, src)
		else
			windoor = new (loc, src)
		if (facing == "l")
			windoor.base_state = "left"
		else
			windoor.base_state = "right"
		transfer_fingerprints_to(windoor)
		playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] finishes \the [windoor] with \a [tool]."),
			SPAN_NOTICE("You finish \the [windoor] with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


//Rotates the windoor assembly clockwise
/obj/structure/windoor_assembly/verb/revrotate()
	set name = "Rotate Windoor Assembly"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		to_chat(usr, "It is fastened to the floor; therefore, you can't rotate it!")
		return 0
	if(src.state != WINDOOR_STATE_FRAME)
		update_nearby_tiles(need_rebuild=1) //Compel updates before

	src.set_dir(turn(src.dir, 270))

	if(src.state != WINDOOR_STATE_FRAME)
		update_nearby_tiles(need_rebuild=1)

	update_icon()
	return

//Flips the windoor assembly, determines whather the door opens to the left or the right
/obj/structure/windoor_assembly/verb/flip()
	set name = "Flip Windoor Assembly"
	set category = "Object"
	set src in oview(1)

	if(src.facing == "l")
		to_chat(usr, "The windoor will now slide to the right.")
		src.facing = "r"
	else
		src.facing = "l"
		to_chat(usr, "The windoor will now slide to the left.")

	update_icon()
	return
