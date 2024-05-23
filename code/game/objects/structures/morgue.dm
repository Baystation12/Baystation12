/* Morgue stuff
 * Contains:
 *		Morgue
 *		Morgue trays
 *		Creamatorium
 *		Creamatorium trays
 */

/*
 * Morgue
 */

/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in until someone fetches them."
	icon = 'icons/obj/structures/morgue_tray.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = TRUE
	var/obj/structure/m_tray/connected = null
	anchored = TRUE

/obj/structure/morgue/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/morgue/proc/update()
	if (src.connected)
		src.icon_state = "morgue0"
	else
		if (length(src.contents))
			src.icon_state = "morgue2"
		else
			src.icon_state = "morgue1"
	return

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(EX_ACT_LIGHT)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/morgue/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
		src.connected = null
	else
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/m_tray( src.loc )
		step(src.connected, src.dir)
		var/turf/T = get_step(src, src.dir)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "morgue0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "morguet"
			src.connected.set_dir(src.dir)
		else
			qdel(src.connected)
			src.connected = null
	src.add_fingerprint(user)
	update()
	return

/obj/structure/morgue/attack_robot(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	return ..()


/obj/structure/morgue/use_tool(obj/item/tool, mob/user, list/click_params)
	// Pen - Add label
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like the label to be? Leave null to clear label.", "\The [initial(name)] - Label") as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!user.use_sanity_check(src, tool))
			return TRUE
		if (!input)
			SetName(initial(name))
			user.visible_message(
				SPAN_NOTICE("\The [user] clears \the [src]'s label with \a [tool]."),
				SPAN_NOTICE("You clear \the [src]'s label with \the [tool].")
			)
		else
			SetName("[initial(name)] - '[input]'")
			user.visible_message(
				SPAN_NOTICE("\The [user] labels \the [src] with \a [tool]."),
				SPAN_NOTICE("You label \the [src] with \the [tool].")
			)
		return TRUE

	return ..()


/obj/structure/morgue/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.connected = new /obj/structure/m_tray( src.loc )
	step(src.connected, EAST)
	var/turf/T = get_step(src, EAST)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "morgue0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
		src.connected.icon_state = "morguet"
	else
		qdel(src.connected)
		src.connected = null
	return


/*
 * Morgue tray
 */
/obj/structure/m_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/structures/morgue_tray.dmi'
	icon_state = "morguet"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	var/obj/structure/morgue/connected = null
	anchored = TRUE
	throwpass = 1

/obj/structure/m_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/m_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/m_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		for(var/mob/B in viewers(user, 3))
			if ((B.client && !( B.blinded )))
				to_chat(B, SPAN_WARNING("\The [user] stuffs [O] into [src]!"))
	return


/*
 * Crematorium
 */

/obj/structure/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon = 'icons/obj/structures/crematorium.dmi'
	icon_state = "crema1"
	density = TRUE
	var/obj/structure/c_tray/connected = null
	anchored = TRUE
	var/cremating = FALSE
	var/id = 1
	var/locked = FALSE

/obj/structure/crematorium/Destroy()
	if(connected)
		qdel(connected)
		connected = null
	return ..()

/obj/structure/crematorium/proc/update()
	if(cremating)
		icon_state = "crema_active"
	else if (src.connected)
		src.icon_state = "crema0"
	else if (length(src.contents))
		src.icon_state = "crema2"
	else
		src.icon_state = "crema1"


/obj/structure/crematorium/ex_act(severity)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.loc)
				ex_act(severity)
			qdel(src)
			return
		if(EX_ACT_HEAVY)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
		if(EX_ACT_LIGHT)
			if (prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(src.loc)
					ex_act(severity)
				qdel(src)
				return
	return

/obj/structure/crematorium/attack_hand(mob/user)
	if(cremating)
		to_chat(usr, SPAN_WARNING("It's locked."))
		return
	if(src.connected && (src.locked == FALSE))
		for(var/atom/movable/A as mob|obj in src.connected.loc)
			if (!( A.anchored ))
				A.forceMove(src)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		qdel(src.connected)
		src.connected = null
	else if(src.locked == 0)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		src.connected = new /obj/structure/c_tray(src.loc)
		step(src.connected, dir)
		var/turf/T = get_step(src, dir)
		if (T.contents.Find(src.connected))
			src.connected.connected = src
			src.icon_state = "crema0"
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(src.connected.loc)
			src.connected.icon_state = "cremat"
		else
			qdel(src.connected)
			src.connected = null
	src.add_fingerprint(user)
	update()


/obj/structure/crematorium/use_tool(obj/item/tool, mob/user, list/click_params)
	// Pen - Add label
	if (istype(tool, /obj/item/pen))
		var/input = input(user, "What would you like the label to be? Leave null to clear label.", "\The [initial(name)] - Label") as null|text
		input = sanitizeSafe(input, MAX_NAME_LEN)
		if (!user.use_sanity_check(src, tool))
			return TRUE
		if (!input)
			SetName(initial(name))
			user.visible_message(
				SPAN_NOTICE("\The [user] clears \the [src]'s label with \a [tool]."),
				SPAN_NOTICE("You clear \the [src]'s label with \the [tool].")
			)
		else
			SetName("[initial(name)] - '[input]'")
			user.visible_message(
				SPAN_NOTICE("\The [user] labels \the [src] with \a [tool]."),
				SPAN_NOTICE("You label \the [src] with \the [tool].")
			)
		return TRUE

	return ..()


/obj/structure/crematorium/relaymove(mob/user as mob)
	if (user.stat || locked)
		return
	src.connected = new /obj/structure/c_tray( src.loc )
	step(src.connected, SOUTH)
	var/turf/T = get_step(src, SOUTH)
	if (T.contents.Find(src.connected))
		src.connected.connected = src
		src.icon_state = "crema0"
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(src.connected.loc)
	else
		qdel(src.connected)
		src.connected = null
	return

/obj/structure/crematorium/proc/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(length(contents) <= 0)
		src.audible_message(SPAN_WARNING("You hear a hollow crackle."), 1)
		return

	else
		if(length(search_contents_for(/obj/item/disk/nuclear)))
			to_chat(loc, "The button's status indicator flashes yellow, indicating that something important is inside the crematorium, and must be removed.")
			return
		src.audible_message(SPAN_WARNING("You hear a roar as the [src] activates."), 1)

		cremating = 1
		locked = 1
		update()

		for(var/mob/living/M in contents)
			admin_attack_log(A, M, "Began cremating their victim.", "Has begun being cremated.", "began cremating")
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				for(var/I, I < 60, I++)
					C.bodytemperature += 50
					C.adjustFireLoss(20)
					C.adjustBrainLoss(5)

					if(C.stat == DEAD || !(C in contents)) //In case we die or are removed at any point.
						cremating = 0
						update()
						break

					sleep(0.5 SECONDS)
					if(prob(40))
						var/desperation = rand(1,5)
						switch(desperation) //This is messy. A better solution would probably be to make more sounds, but...
							if(1)
								playsound(src.loc, 'sound/weapons/genhit.ogg', 45, 1)
								shake_animation(2)
								playsound(src.loc, 'sound/weapons/genhit.ogg', 45, 1)
							if(2)
								playsound(src.loc, 'sound/effects/grillehit.ogg', 45, 1)
								shake_animation(3)
								playsound(src.loc, 'sound/effects/grillehit.ogg', 45, 1)
							if(3)
								playsound(src, 'sound/effects/bang.ogg', 45, 1)
								if(prob(50))
									playsound(src, 'sound/effects/bang.ogg', 45, 1)
									shake_animation()
								else
									shake_animation(5)
							if(4)
								playsound(src, 'sound/effects/clang.ogg', 45, 1)
								shake_animation(5)
							if(5)
								playsound(src, 'sound/weapons/smash.ogg', 50, 1)
								if(prob(50))
									playsound(src, 'sound/weapons/smash.ogg', 50, 1)
									shake_animation(9)
								else
									shake_animation()


			if(M.stat == DEAD)
				if(round_is_spooky())
					if(prob(50))
						playsound(src, 'sound/effects/ghost.ogg', 10, 5)
					else
						playsound(src, 'sound/effects/ghost2.ogg', 10, 5)

				admin_attack_log(A, M, "Cremated their victim.", "Was cremated.", "cremated alive")
				M.audible_message("[M]'s screams cease, as does any movement within the [src]. All that remains is a dull, empty silence.")
				M.dust()

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/decal/cleanable/ash(src)
		sleep(30)
		cremating = initial(cremating)
		locked = initial(locked)
		update()
		playsound(src.loc, 'sound/effects/spray.ogg', 50, 1)
	return

/*
 * Crematorium tray
 */
/obj/structure/c_tray
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon = 'icons/obj/structures/crematorium.dmi'
	icon_state = "cremat"
	density = TRUE
	layer = BELOW_OBJ_LAYER
	var/obj/structure/crematorium/connected = null
	anchored = TRUE
	throwpass = 1

/obj/structure/c_tray/Destroy()
	if(connected && connected.connected == src)
		connected.connected = null
	connected = null
	return ..()

/obj/structure/c_tray/attack_hand(mob/user as mob)
	if (src.connected)
		for(var/atom/movable/A as mob|obj in src.loc)
			if (!( A.anchored ))
				A.forceMove(src.connected)
		src.connected.connected = null
		src.connected.update()
		add_fingerprint(user)
		//SN src = null
		qdel(src)
		return
	return

/obj/structure/c_tray/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if ((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src) || user.contents.Find(O)))
		return
	if (!ismob(O) && !istype(O, /obj/structure/closet/body_bag))
		return
	if (!ismob(user) || user.stat || user.lying || user.stunned)
		return
	O.forceMove(src.loc)
	if (user != O)
		user.visible_message(SPAN_WARNING("\The [user] stuffs \the [O] into \the [src]!"))

/obj/machinery/button/crematorium
	name = "crematorium igniter"
	desc = "Burn baby burn!"
	icon = 'icons/obj/structures/buttons.dmi'
	icon_state = "blastctrl"
	req_access = list(access_crematorium)
	id_tag = 1

/obj/machinery/button/crematorium/activate(mob/user)
	if(operating)
		return
	for(var/obj/structure/crematorium/C in range())
		if (C.id == id_tag)
			if (!C.cremating)
				C.cremate(user)
	..() // sets operating for click cooldown.
