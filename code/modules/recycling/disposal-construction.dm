// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

/obj/structure/disposalconstruct
	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = FALSE
	density = FALSE
	matter = list(MATERIAL_STEEL = 1850)
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_ANCHORABLE
	var/sort_type = ""
	var/dpdir = 0	// directions as disposalpipe
	var/turn = DISPOSAL_FLIP_FLIP
	var/constructed_path = /obj/structure/disposalpipe
	var/built_icon_state

/obj/structure/disposalconstruct/New(loc, P = null)
	. = ..()
	if(P)
		if(istype(P, /obj/structure/disposalpipe))//Unfortunately a necessary evil since some things are machines and other things are structures
			var/obj/structure/disposalpipe/D = P
			SetName(D.name)
			desc = D.desc
			icon = D.icon
			built_icon_state = D.icon_state
			anchored = D.anchored
			set_density(D.density)
			turn = D.turn
			sort_type = D.sort_type
			dpdir = D.dpdir
			constructed_path = D.type
			set_dir(D.dir) // Needs to be set after turn and possibly other state.
		if(istype(P, /obj/machinery/disposal))
			var/obj/machinery/disposal/D = P
			SetName(D.name)
			desc = D.desc
			icon = D.icon
			built_icon_state = D.icon_state
			anchored = D.anchored
			set_density(D.density)
			turn = D.turn
			constructed_path = D.type
			set_dir(D.dir)
	update_icon()

/obj/structure/disposalconstruct/Initialize()
	update_verbs()
	. = ..()

/obj/structure/disposalconstruct/proc/update_verbs()
	if(anchored)
		verbs -= /obj/structure/disposalconstruct/proc/flip
	else
		verbs += /obj/structure/disposalconstruct/proc/flip

// update iconstate and dpdir due to dir and type
/obj/structure/disposalconstruct/proc/update()
	if(invisibility)      // if invisible, fade icon
		alpha = 128
	else
		alpha = 255
		//otherwise burying half-finished pipes under floors causes them to half-fade

// hide called by levelupdate if turf intact status changes
// change visibility status and force update of icon
/obj/structure/disposalconstruct/hide(intact)
	set_invisibility((intact && level==ATOM_LEVEL_UNDER_TILE) ? 101: 0)	// hide if floor is intact
	update()

/obj/structure/disposalconstruct/proc/flip()
	set category = "Object"
	set name = "Flip Pipe"
	set src in view(1)
	if(usr.incapacitated())
		return

	if(anchored)
		to_chat(usr, "You must unfasten the pipe before flipping it.")
		return

	if(ispath(constructed_path, /obj/structure/disposalpipe))
		var/obj/structure/disposalpipe/fake_pipe = constructed_path
		if(initial(fake_pipe.flipped_state))
			constructed_path = initial(fake_pipe.flipped_state)
			fake_pipe = constructed_path
			turn = initial(fake_pipe.turn)
			built_icon_state = initial(fake_pipe.icon_state)
			set_dir(dir) // run the update, as our dpdir is probably wrong after this
			update_icon()
			return
	set_dir(turn(dir, 180))

/obj/structure/disposalconstruct/on_update_icon()
	if("con[built_icon_state]" in icon_states(icon))
		icon_state = "con[built_icon_state]"
	else
		icon_state = built_icon_state

/obj/structure/disposalconstruct/proc/flip_dirs(flipvalue)
	. = dir
	if(flipvalue & DISPOSAL_FLIP_FLIP)
		. |= turn(dir,180)
	if(flipvalue & DISPOSAL_FLIP_LEFT)
		. |= turn(dir,90)
	if(flipvalue & DISPOSAL_FLIP_RIGHT)
		. |= turn(dir,-90)

/obj/structure/disposalconstruct/set_dir(new_dir)
	. = ..()
	dpdir = flip_dirs(turn) //does the flipping stuff
	update()

/obj/structure/disposalconstruct/Move()
	var/old_dir = dir
	. = ..()
	set_dir(old_dir)


/obj/structure/disposalconstruct/can_anchor(obj/item/tool, mob/user, silent)
	. = ..()
	if (!.)
		return
	if (!anchored)
		// Plating
		var/turf/turf = get_turf(src)
		if (!turf.is_plating())
			if (!silent)
				USE_FEEDBACK_FAILURE("You must remove the plating before you can secure \the [src].")
			return FALSE

		// Catwalks
		var/obj/structure/catwalk/catwalk = locate() in get_turf(src)
		if (catwalk)
			if (catwalk.plated_tile && !catwalk.hatch_open)
				if (!silent)
					USE_FEEDBACK_FAILURE("\The [catwalk]'s hatch needs to be opened before you can secure \the [src].")
				return FALSE
			else if (!catwalk.plated_tile)
				if (!silent)
					USE_FEEDBACK_FAILURE("\The [catwalk] is blocking access to the floor.")
				return FALSE

		var/obj/structure/disposalpipe/connected_pipe = locate() in get_turf(src)
		if (!check_buildability(connected_pipe, user))
			return FALSE


/obj/structure/disposalconstruct/post_anchor_change()
	wrench_down(anchored)
	update()
	update_verbs()
	..()


/obj/structure/disposalconstruct/use_tool(obj/item/tool, mob/user, list/click_params)
	var/obj/structure/disposalpipe/connected_pipe = locate() in get_turf(src)

	// Welding Tool - Weld into place
	if (isWelder(tool))
		if (!anchored)
			USE_FEEDBACK_FAILURE("\The [src] needs to be anchored to the floor before you can weld it.")
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(1, user, "to weld \the [src] down."))
			return TRUE
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts welding \the [src] down with \a [tool]."),
			SPAN_NOTICE("You start welding \the [src] down with \the [tool]."),
			SPAN_ITALIC("You hear welding.")
		)
		if (!user.do_skilled((tool.toolspeed * 2) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool) || !welder.remove_fuel(1, user))
			return TRUE
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] welds \the [src] down with \a [tool]."),
			SPAN_NOTICE("You weld \the [src] down with \the [tool].")
		)
		build(connected_pipe)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/disposalconstruct/hides_under_flooring()
	return anchored

/obj/structure/disposalconstruct/proc/check_buildability(obj/structure/disposalpipe/CP, mob/user)
	if(!CP)
		return TRUE
	var/pdir = CP.dpdir
	if(istype(CP, /obj/structure/disposalpipe/broken))
		pdir = CP.dir
	if(pdir & dpdir)
		to_chat(user, "There is already a disposals pipe at that location.")
		return FALSE
	return TRUE

/obj/structure/disposalconstruct/proc/wrench_down(anchor)
	if(anchor)
		anchored = TRUE
		level = ATOM_LEVEL_UNDER_TILE // We don't want disposal bins to disappear under the floors
		set_density(0)
	else
		anchored = FALSE
		level = ATOM_LEVEL_OVER_TILE
		set_density(1)

/obj/structure/disposalconstruct/machine/check_buildability(obj/structure/disposalpipe/CP, mob/user)
	if(CP) // There's something there
		if(!istype(CP,/obj/structure/disposalpipe/trunk))
			to_chat(user, "\The [src] requires a trunk underneath it in order to work.")
			return FALSE
		return TRUE
	// Nothing under, fuck.
	to_chat(user, "\The [src] requires a trunk underneath it in order to work.")
	return FALSE

/obj/structure/disposalconstruct/proc/build()
	var/obj/structure/disposalpipe/P = new constructed_path(loc)
	transfer_fingerprints_to(P)
	P.base_icon_state = built_icon_state
	P.icon_state = built_icon_state
	P.dpdir = dpdir
	P.sort_type = sort_type
	P.set_dir(dir)
	P.on_build()

// Subtypes

/obj/structure/disposalconstruct/machine/update_verbs()
	return // No flipping

/obj/structure/disposalconstruct/machine/wrench_down(anchor)
	anchored = anchor
	set_density(1) // We don't want disposal bins or outlets to go density 0
	update_icon()

/obj/structure/disposalconstruct/machine/build(obj/structure/disposalpipe/CP)
	var/obj/machinery/disposal/P = new constructed_path(src.loc)
	transfer_fingerprints_to(P)
	P.set_dir(dir)
	P.mode = 0 // start with pump off

/obj/structure/disposalconstruct/machine/on_update_icon()
	if(anchored)
		icon_state = built_icon_state
	else
		..()

/obj/structure/disposalconstruct/machine/outlet/build(obj/structure/disposalpipe/CP)
	var/obj/structure/disposaloutlet/P = new constructed_path(loc)
	transfer_fingerprints_to(P)
	P.set_dir(dir)
	var/obj/structure/disposalpipe/trunk/Trunk = CP
	Trunk.linked = P
