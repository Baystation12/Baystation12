// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

/obj/structure/disposalconstruct

	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = 0
	density = 0
	pressure_resistance = 5*ONE_ATMOSPHERE
	matter = list("metal" = 1850)
	level = 2
	var/ptype = 0
	// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk, 6=disposal bin, 7=outlet, 8=inlet

	var/dpdir = 0	// directions as disposalpipe
	var/base_state = "pipe-s"

	// update iconstate and dpdir due to dir and type
	proc/update()
		var/flip = turn(dir, 180)
		var/left = turn(dir, 90)
		var/right = turn(dir, -90)

		switch(ptype)
			if(0)
				base_state = "pipe-s"
				dpdir = dir | flip
			if(1)
				base_state = "pipe-c"
				dpdir = dir | right
			if(2)
				base_state = "pipe-j1"
				dpdir = dir | right | flip
			if(3)
				base_state = "pipe-j2"
				dpdir = dir | left | flip
			if(4)
				base_state = "pipe-y"
				dpdir = dir | left | right
			if(5)
				base_state = "pipe-t"
				dpdir = dir
			 // disposal bin has only one dir, thus we don't need to care about setting it
			if(6)
				if(anchored)
					base_state = "disposal"
				else
					base_state = "condisposal"

			if(7)
				base_state = "outlet"
				dpdir = dir

			if(8)
				base_state = "intake"
				dpdir = dir

			if(9)
				base_state = "pipe-j1s"
				dpdir = dir | right | flip

			if(10)
				base_state = "pipe-j2s"
				dpdir = dir | left | flip
///// Z-Level stuff
			if(11)
				base_state = "pipe-u"
				dpdir = dir
			if(12)
				base_state = "pipe-d"
				dpdir = dir
///// Z-Level stuff
			if(13)
				base_state = "pipe-tagger"
				dpdir = dir | flip
			if(14)
				base_state = "pipe-tagger-partial"
				dpdir = dir | flip


///// Z-Level stuff
		if(ptype<6 || ptype>8 && !(ptype==11 || ptype==12))
///// Z-Level stuff
			icon_state = "con[base_state]"
		else
			icon_state = base_state

		if(invisibility)				// if invisible, fade icon
			alpha = 128

	// hide called by levelupdate if turf intact status changes
	// change visibility status and force update of icon
	hide(var/intact)
		invisibility = (intact && level==1) ? 101: 0	// hide if floor is intact
		update()


	// flip and rotate verbs
	verb/rotate()
		set category = "Object"
		set name = "Rotate Pipe"
		set src in view(1)

		if(usr.stat)
			return

		if(anchored)
			usr << "You must unfasten the pipe before rotating it."
			return

		set_dir(turn(dir, -90))
		update()

	verb/flip()
		set category = "Object"
		set name = "Flip Pipe"
		set src in view(1)
		if(usr.stat)
			return

		if(anchored)
			usr << "You must unfasten the pipe before flipping it."
			return

		set_dir(turn(dir, 180))
		switch(ptype)
			if(2)
				ptype = 3
			if(3)
				ptype = 2
			if(9)
				ptype = 10
			if(10)
				ptype = 9

		update()

	// returns the type path of disposalpipe corresponding to this item dtype
	proc/dpipetype()
		switch(ptype)
			if(0,1)
				return /obj/structure/disposalpipe/segment
			if(2,3,4)
				return /obj/structure/disposalpipe/junction
			if(5)
				return /obj/structure/disposalpipe/trunk
			if(6)
				return /obj/machinery/disposal
			if(7)
				return /obj/structure/disposaloutlet
			if(8)
				return /obj/machinery/disposal/deliveryChute
			if(9)
				return /obj/structure/disposalpipe/sortjunction
			if(10)
				return /obj/structure/disposalpipe/sortjunction/flipped
///// Z-Level stuff
			if(11)
				return /obj/structure/disposalpipe/up
			if(12)
				return /obj/structure/disposalpipe/down
///// Z-Level stuff
			if(13)
				return /obj/structure/disposalpipe/tagger
			if(14)
				return /obj/structure/disposalpipe/tagger/partial
		return



	// attackby item
	// wrench: (un)anchor
	// weldingtool: convert to real pipe

	attackby(var/obj/item/I, var/mob/user)
		var/nicetype = "pipe"
		var/ispipe = 0 // Indicates if we should change the level of this pipe
		src.add_fingerprint(user)
		switch(ptype)
			if(6)
				nicetype = "disposal bin"
			if(7)
				nicetype = "disposal outlet"
			if(8)
				nicetype = "delivery chute"
			if(9, 10)
				nicetype = "sorting pipe"
				ispipe = 1
			if(13)
				nicetype = "tagging pipe"
				ispipe = 1
			if(14)
				nicetype = "partial tagging pipe"
				ispipe = 1
			else
				nicetype = "pipe"
				ispipe = 1

		var/turf/T = src.loc
		if(T.intact)
			user << "You can only attach the [nicetype] if the floor plating is removed."
			return

		var/obj/structure/disposalpipe/CP = locate() in T

		if(istype(I, /obj/item/weapon/wrench))
			if(anchored)
				anchored = 0
				if(ispipe)
					level = 2
					density = 0
				else
					density = 1
				user << "You detach the [nicetype] from the underfloor."
			else
				if(ptype>=6 && ptype <= 8) // Disposal or outlet
					if(CP) // There's something there
						if(!istype(CP,/obj/structure/disposalpipe/trunk))
							user << "The [nicetype] requires a trunk underneath it in order to work."
							return
					else // Nothing under, fuck.
						user << "The [nicetype] requires a trunk underneath it in order to work."
						return
				else
					if(CP)
						update()
						var/pdir = CP.dpdir
						if(istype(CP, /obj/structure/disposalpipe/broken))
							pdir = CP.dir
						if(pdir & dpdir)
							user << "There is already a [nicetype] at that location."
							return

				anchored = 1
				if(ispipe)
					level = 1 // We don't want disposal bins to disappear under the floors
					density = 0
				else
					density = 1 // We don't want disposal bins or outlets to go density 0
				user << "You attach the [nicetype] to the underfloor."
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			update()

		else if(istype(I, /obj/item/weapon/weldingtool))
			if(anchored)
				var/obj/item/weapon/weldingtool/W = I
				if(W.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
					user << "Welding the [nicetype] in place."
					if(do_after(user, 20))
						if(!src || !W.isOn()) return
						user << "The [nicetype] has been welded in place!"
						update() // TODO: Make this neat
						if(ispipe) // Pipe

							var/pipetype = dpipetype()
							var/obj/structure/disposalpipe/P = new pipetype(src.loc)
							src.transfer_fingerprints_to(P)
							P.base_icon_state = base_state
							P.set_dir(dir)
							P.dpdir = dpdir
							P.updateicon()

							//Needs some special treatment ;)
							if(ptype==9 || ptype==10)
								var/obj/structure/disposalpipe/sortjunction/SortP = P
								SortP.updatedir()

						else if(ptype==6) // Disposal bin
							var/obj/machinery/disposal/P = new /obj/machinery/disposal(src.loc)
							src.transfer_fingerprints_to(P)
							P.mode = 0 // start with pump off

						else if(ptype==7) // Disposal outlet

							var/obj/structure/disposaloutlet/P = new /obj/structure/disposaloutlet(src.loc)
							src.transfer_fingerprints_to(P)
							P.set_dir(dir)
							var/obj/structure/disposalpipe/trunk/Trunk = CP
							Trunk.linked = P

						else if(ptype==8) // Disposal outlet

							var/obj/machinery/disposal/deliveryChute/P = new /obj/machinery/disposal/deliveryChute(src.loc)
							src.transfer_fingerprints_to(P)
							P.set_dir(dir)

						del(src)
						return
				else
					user << "You need more welding fuel to complete this task."
					return
			else
				user << "You need to attach it to the plating first!"
				return
