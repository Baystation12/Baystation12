// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

/obj/structure/disposalconstruct

	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = 0
	density = 0
	matter = list(MATERIAL_STEEL = 1850)
	level = 2
	var/sortType = ""
	var/ptype = DISPOSAL_STRAIGHT
	var/subtype = 0
	var/dpdir = 0	// directions as disposalpipe

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
	var/flip = turn(dir, 180)
	var/left = turn(dir, 90)
	var/right = turn(dir, -90)

	switch(ptype)
		if(DISPOSAL_STRAIGHT)
			icon_state = "conpipe-s"
			dpdir = dir | flip
		if(DISPOSAL_BENT)
			icon_state = "conpipe-c"
			dpdir = dir | right
		if(DISPOSAL_JUNCTION1)
			icon_state = "conpipe-j1"
			dpdir = dir | right | flip
		if(DISPOSAL_JUNCTION2)
			icon_state = "conpipe-j2"
			dpdir = dir | left | flip
		if(DISPOSAL_JUNCTION_Y)
			icon_state = "conpipe-y"
			dpdir = dir | left | right
		if(DISPOSAL_TRUNK)
			icon_state = "conpipe-t"
			dpdir = dir
		 // disposal bin has only one dir, thus we don't need to care about setting it
		if(DISPOSAL_BIN)
			if(anchored)
				icon_state = "disposal"
			else
				icon_state = "condisposal"
		if(DISPOSAL_OUTLET)
			icon_state = "outlet"
			dpdir = dir
		if(DISPOSAL_INLET)
			icon_state = "intake"
			dpdir = dir
		if(DISPOSAL_JUNCTION_SORT1)
			icon_state = "conpipe-j1s"
			dpdir = dir | right | flip
		if(DISPOSAL_JUNCTION_SORT2)
			icon_state = "conpipe-j2s"
			dpdir = dir | left | flip
		if(DISPOSAL_UP)
			icon_state = "pipe-u"
			dpdir = dir
		if(DISPOSAL_DOWN)
			icon_state = "pipe-d"
			dpdir = dir
		if(DISPOSAL_TAGGER)
			icon_state = "pipe-tagger"
			dpdir = dir | flip
		if(DISPOSAL_TAGGER_PARTIAL)
			icon_state = "pipe-tagger-partial"
			dpdir = dir | flip
		if(DISPOSAL_DIVERSION)
			icon_state = "conpipe-j1s"
			dpdir = dir | flip

	if(invisibility)				// if invisible, fade icon
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

	set_dir(turn(dir, 180))
	switch(ptype)
		if(DISPOSAL_JUNCTION1)
			ptype = DISPOSAL_JUNCTION2
		if(DISPOSAL_JUNCTION2)
			ptype = DISPOSAL_JUNCTION1
		if(DISPOSAL_JUNCTION_SORT1)
			ptype = DISPOSAL_JUNCTION_SORT2
		if(DISPOSAL_JUNCTION_SORT2)
			ptype = DISPOSAL_JUNCTION_SORT1

	update()

// returns the type path of disposalpipe corresponding to this item dtype
/obj/structure/disposalconstruct/proc/dpipetype()
	switch(ptype)
		if(DISPOSAL_STRAIGHT,DISPOSAL_BENT)
			return /obj/structure/disposalpipe/segment
		if(DISPOSAL_JUNCTION1,DISPOSAL_JUNCTION2,DISPOSAL_JUNCTION_Y)
			return /obj/structure/disposalpipe/junction
		if(DISPOSAL_TRUNK)
			return /obj/structure/disposalpipe/trunk
		if(DISPOSAL_BIN)
			return /obj/machinery/disposal
		if(DISPOSAL_OUTLET)
			return /obj/structure/disposaloutlet
		if(DISPOSAL_INLET)
			return /obj/machinery/disposal/deliveryChute
		if(DISPOSAL_JUNCTION_SORT1)
			switch(subtype)
				if(DISPOSAL_SUB_SORT_NORMAL)
					return /obj/structure/disposalpipe/sortjunction
				if(DISPOSAL_SUB_SORT_WILD)
					return /obj/structure/disposalpipe/sortjunction/wildcard
				if(DISPOSAL_SUB_SORT_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged
		if(DISPOSAL_JUNCTION_SORT2)
			switch(subtype)
				if(DISPOSAL_SUB_SORT_NORMAL)
					return /obj/structure/disposalpipe/sortjunction/flipped
				if(DISPOSAL_SUB_SORT_WILD)
					return /obj/structure/disposalpipe/sortjunction/wildcard/flipped
				if(DISPOSAL_SUB_SORT_UNTAGGED)
					return /obj/structure/disposalpipe/sortjunction/untagged/flipped
///// Z-Level stuff
		if(DISPOSAL_UP)
			return /obj/structure/disposalpipe/up
		if(DISPOSAL_DOWN)
			return /obj/structure/disposalpipe/down
///// Z-Level stuff
		if(DISPOSAL_TAGGER)
			return /obj/structure/disposalpipe/tagger
		if(DISPOSAL_TAGGER_PARTIAL)
			return /obj/structure/disposalpipe/tagger/partial
		if(DISPOSAL_DIVERSION)
			return /obj/structure/disposalpipe/diversion_junction
	return



// attackby item
// wrench: (un)anchor
// weldingtool: convert to real pipe
/obj/structure/disposalconstruct/attackby(var/obj/item/I, var/mob/user)
	var/nicetype = "pipe"
	var/ispipe = 0 // Indicates if we should change the level of this pipe
	add_fingerprint(user, 0, I)
	switch(ptype)
		if(DISPOSAL_BIN)
			nicetype = "disposal bin"
		if(DISPOSAL_OUTLET)
			nicetype = "disposal outlet"
		if(DISPOSAL_INLET)
			nicetype = "delivery chute"
		if(DISPOSAL_JUNCTION_SORT1, DISPOSAL_JUNCTION_SORT2)
			switch(subtype)
				if(DISPOSAL_SUB_SORT_NORMAL)
					nicetype = "sorting pipe"
				if(DISPOSAL_SUB_SORT_WILD)
					nicetype = "wildcard sorting pipe"
				if(DISPOSAL_SUB_SORT_UNTAGGED)
					nicetype = "untagged sorting pipe"
			ispipe = 1
		if(DISPOSAL_TAGGER)
			nicetype = "tagging pipe"
			ispipe = 1
		if(DISPOSAL_TAGGER_PARTIAL)
			nicetype = "partial tagging pipe"
			ispipe = 1
		else
			nicetype = "pipe"
			ispipe = 1

	var/turf/T = src.loc
	if(!T.is_plating())
		to_chat(user, "You can only attach the [nicetype] if the floor plating is removed.")
		return

	var/obj/structure/disposalpipe/CP = locate() in T

	if(isWrench(I))
		if(anchored)
			anchored = 0
			if(ispipe)
				level = 2
				set_density(0)
			else
				set_density(1)
			to_chat(user, "You detach the [nicetype] from the underfloor.")
		else
			if(ptype>=DISPOSAL_BIN && ptype <= DISPOSAL_INLET) // Disposal or outlet
				if(CP) // There's something there
					if(!istype(CP,/obj/structure/disposalpipe/trunk))
						to_chat(user, "The [nicetype] requires a trunk underneath it in order to work.")
						return
				else // Nothing under, fuck.
					to_chat(user, "The [nicetype] requires a trunk underneath it in order to work.")
					return
			else
				if(CP)
					update()
					var/pdir = CP.dpdir
					if(istype(CP, /obj/structure/disposalpipe/broken))
						pdir = CP.dir
					if(pdir & dpdir)
						to_chat(user, "There is already a [nicetype] at that location.")
						return

			anchored = 1
			if(ispipe)
				level = 1 // We don't want disposal bins to disappear under the floors
				set_density(0)
			else
				set_density(1) // We don't want disposal bins or outlets to go density 0
			to_chat(user, "You attach the [nicetype] to the underfloor.")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		update()
		update_verbs()

	else if(istype(I, /obj/item/weapon/weldingtool))
		if(anchored)
			var/obj/item/weapon/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "Welding the [nicetype] in place.")
				if(do_after(user, 20, src))
					if(!src || !W.isOn()) return
					to_chat(user, "The [nicetype] has been welded in place!")
					update() // TODO: Make this neat
					if(ispipe) // Pipe

						var/pipetype = dpipetype()
						var/obj/structure/disposalpipe/P = new pipetype(src.loc)
						src.transfer_fingerprints_to(P)
						P.base_icon_state = icon_state
						P.set_dir(dir)
						P.dpdir = dpdir
						P.update_icon()

						//Needs some special treatment ;)
						if(ptype==DISPOSAL_JUNCTION_SORT1 || ptype==DISPOSAL_JUNCTION_SORT2)
							var/obj/structure/disposalpipe/sortjunction/SortP = P
							SortP.sortType = sortType
							SortP.updatedir()
							SortP.updatedesc()
							SortP.updatename()

					else if(ptype==DISPOSAL_BIN) // Disposal bin
						var/obj/machinery/disposal/P = new /obj/machinery/disposal(src.loc)
						src.transfer_fingerprints_to(P)
						P.mode = 0 // start with pump off

					else if(ptype==DISPOSAL_OUTLET) // Disposal outlet

						var/obj/structure/disposaloutlet/P = new /obj/structure/disposaloutlet(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)
						var/obj/structure/disposalpipe/trunk/Trunk = CP
						Trunk.linked = P

					else if(ptype==DISPOSAL_INLET) // Disposal outlet

						var/obj/machinery/disposal/deliveryChute/P = new /obj/machinery/disposal/deliveryChute(src.loc)
						src.transfer_fingerprints_to(P)
						P.set_dir(dir)

					qdel(src)
					return
			else
				to_chat(user, "You need more welding fuel to complete this task.")
				return
		else
			to_chat(user, "You need to attach it to the plating first!")
			return

/obj/structure/disposalconstruct/hides_under_flooring()
	if(anchored)
		return 1
	else
		return 0
