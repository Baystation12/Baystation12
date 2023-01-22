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
	level = 2
	obj_flags = OBJ_FLAG_ROTATABLE
	var/sort_type = ""
	var/dpdir = 0	// directions as disposalpipe
	var/turn = DISPOSAL_FLIP_FLIP
	var/constructed_path = /obj/structure/disposalpipe
	var/built_icon_state

/obj/structure/disposalconstruct/New(loc, var/P = null)
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
/obj/structure/disposalconstruct/hide(var/intact)
	set_invisibility((intact && level==1) ? 101: 0)	// hide if floor is intact
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

/obj/structure/disposalconstruct/proc/flip_dirs(var/flipvalue)
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

// attackby item
// wrench: (un)anchor
// weldingtool: convert to real pipe
/obj/structure/disposalconstruct/attackby(var/obj/item/I, var/mob/user)
	var/turf/T = loc
	if(!istype(T))
		return
	if(!T.is_plating())
		to_chat(user, "You can only manipulate \the [src] if the floor plating is removed.")
		return

	var/obj/structure/disposalpipe/CP = locate() in T

	if(isWrench(I))
		if(anchored)
			anchored = FALSE
			wrench_down(FALSE)
			to_chat(user, "You detach \the [src] from the underfloor.")
		else
			if(!check_buildability(CP, user))
				return
			wrench_down(TRUE)
			to_chat(user, "You attach \the [src] to the underfloor.")
		playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
		update()
		update_verbs()

	else if(istype(I, /obj/item/weldingtool))
		if(anchored)
			var/obj/item/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "Welding \the [src] in place.")
				if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
					if(!src || !W.isOn()) return
					to_chat(user, "\The [src] has been welded in place!")
					build(CP)
					qdel(src)
					return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return
		else
			to_chat(user, "You need to attach it to the plating first!")
			return

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
		level = 1 // We don't want disposal bins to disappear under the floors
		set_density(0)
	else
		anchored = FALSE
		level = 2
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

/obj/structure/disposalconstruct/machine
	obj_flags = 0 // No rotating

/obj/structure/disposalconstruct/machine/update_verbs()
	return // No flipping

/obj/structure/disposalconstruct/machine/wrench_down(anchor)
	anchored = anchor
	set_density(1) // We don't want disposal bins or outlets to go density 0
	update_icon()

/obj/structure/disposalconstruct/machine/build(obj/structure/disposalpipe/CP)
	var/obj/machinery/disposal/P = new /obj/machinery/disposal(src.loc)
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
