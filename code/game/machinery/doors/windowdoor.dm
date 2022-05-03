/obj/machinery/door/window
	name = "interior door"
	desc = "A strong door."
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "left"
	var/base_state = "left"
	min_force = 4
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 150 //If you change this, consiter changing ../door/window/brigdoor/ health at the bottom of this .dm file
	health = 150
	visible = 0.0
	use_power = POWER_USE_OFF
	stat_immune = NOSCREEN | NOINPUT | NOPOWER
	uncreated_component_parts = null
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CHECKS_BORDER
	opacity = 0
	var/obj/item/airlock_electronics/electronics = null
	explosion_resistance = 5
	air_properties_vary_with_direction = 1
	pry_mod = 0.5

/obj/machinery/door/window/New()
	..()
	update_nearby_tiles()

/obj/machinery/door/window/Initialize(mapload, obj/structure/windoor_assembly/assembly)
	if(assembly)
		set_dir(assembly.dir)
		set_density(0)
		if(assembly.electronics)
			if(assembly.electronics.autoset)
				autoset_access = TRUE // Being careful in case of subtypes or something.
			else
				req_access = assembly.electronics.conf_access
				if(assembly.electronics.one_access)
					req_access = list(req_access)
				autoset_access = FALSE
			electronics = assembly.electronics
			electronics.forceMove(src)
	. = ..()

/obj/machinery/door/window/on_update_icon()
	if(density)
		icon_state = base_state
	else
		icon_state = "[base_state]open"

/obj/machinery/door/window/proc/shatter(var/display_message = 1)
	new /obj/item/material/shard(src.loc)
	var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src.loc)
	CC.amount = 2
	var/obj/item/airlock_electronics/ae
	if(!electronics)
		create_electronics()
	ae = electronics
	electronics = null
	ae.dropInto(loc)
	if(operating == -1)
		ae.icon_state = "door_electronics_smoked"
		operating = 0
	set_density(0)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	qdel(src)

/obj/machinery/door/window/deconstruct(mob/user, var/moved = FALSE)
	shatter()

/obj/machinery/door/window/Destroy()
	set_density(0)
	update_nearby_tiles()
	return ..()

/obj/machinery/door/window/Bumped(atom/movable/AM as mob|obj)
	if (!( ismob(AM) ))
		var/mob/living/bot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.botcard))
				open()
				addtimer(CALLBACK(src, .proc/close), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		return
	var/mob/M = AM // we've returned by here if M is not a mob
	if (src.operating)
		return
	if (src.density && (!issmall(M) || ishuman(M) || issilicon(M)) && src.allowed(AM))
		open()
		var/open_timer
		if(src.check_access(null))
			open_timer = 5 SECONDS
		else //secure doors close faster
			open_timer = 2 SECONDS
		addtimer(CALLBACK(src, .proc/close), open_timer, TIMER_UNIQUE | TIMER_OVERRIDE)
	return

/obj/machinery/door/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) & dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/machinery/door/window/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/machinery/door/window/open()
	if (operating == 1) //doors can still open when emag-disabled
		return 0
	if (!src.operating) //in case of emag
		src.operating = 1

	icon_state = "[src.base_state]open";
	flick("[src.base_state]opening", src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 100, 1)
	addtimer(CALLBACK(src, .proc/open_final), 1 SECOND, TIMER_UNIQUE | TIMER_OVERRIDE)

	return 1

/obj/machinery/door/window/proc/open_final()
	explosion_resistance = 0
	set_density(FALSE)
	update_icon()
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0

/obj/machinery/door/window/close()
	if (src.operating)
		return 0
	operating = 1
	flick(text("[]closing", src.base_state), src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 100, 1)
	set_density(1)
	update_icon()
	explosion_resistance = initial(explosion_resistance)
	update_nearby_tiles()

	addtimer(CALLBACK(src, .proc/close_final), 1 SECOND, TIMER_UNIQUE | TIMER_OVERRIDE)
	return TRUE

/obj/machinery/door/window/proc/close_final()
	operating = 0

/obj/machinery/door/window/take_damage(var/damage)
	src.health = max(0, src.health - damage)
	if (src.health <= 0)
		shatter()
		return

/obj/machinery/door/window/physical_attack_hand(mob/user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
			visible_message("<span class='danger'>[user] smashes against the [src.name].</span>", 1)
			take_damage(25)
			return TRUE

/obj/machinery/door/window/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, SPAN_WARNING("\The [src] has already been locked open."))
		return FALSE
	if (!operable())
		to_chat(user, SPAN_WARNING("\The [src] is not functioning and doesn't respond to your attempt to short the circuitry."))
		return FALSE

	operating = -1
	emagged = TRUE
	to_chat(user, SPAN_NOTICE("You short out \the [src]'s internal circuitry, locking it open!"))
	if (density)
		flick("[base_state]spark", src)
		addtimer(CALLBACK(src, .proc/open), 6, TIMER_UNIQUE | TIMER_OVERRIDE)
	return TRUE

/obj/machinery/door/window/emp_act(severity)
	if(prob(20/severity))
		spawn(0)
			open()
	..()

/obj/machinery/door/window/CanFluidPass(var/coming_from)
	return !density || ((dir in GLOB.cardinal) && coming_from != dir)

/obj/machinery/door/window/attackby(obj/item/I as obj, mob/user as mob)

	//If it's in the process of opening/closing, ignore the click
	if (src.operating == 1)
		return

	//Emags and ninja swords? You may pass.
	if (istype(I, /obj/item/melee/energy/blade))
		if(emag_act(10, user))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, "sparks", 50, 1)
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			visible_message("<span class='warning'>The glass door was sliced open by [user]!</span>")
		return 1

	//If it's emagged, crowbar can pry electronics out.
	if (src.operating == -1 && isCrowbar(I))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("[user] removes the electronics from the windoor.", "You start to remove electronics from the windoor.")
		if (do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, "<span class='notice'>You removed the windoor electronics!</span>")

			var/obj/structure/windoor_assembly/wa = new/obj/structure/windoor_assembly(src.loc)
			if (istype(src, /obj/machinery/door/window/brigdoor))
				wa.secure = "secure_"
				wa.SetName("Secure Wired Windoor Assembly")
			else
				wa.SetName("Wired Windoor Assembly")
			if (src.base_state == "right" || src.base_state == "rightsecure")
				wa.facing = "r"
			wa.set_dir(src.dir)
			wa.state = "02"
			wa.update_icon()

			shatter(src)
			operating = 0
			return

	if (check_force(I, user))
		return

	src.add_fingerprint(user, 0, I)

	if (src.allowed(user))
		if (src.density)
			open()
		else
			if (emagged)
				to_chat(user, SPAN_WARNING("\The [src] seems to be stuck and refuses to close!"))
				return
			close()

	else if (src.density)
		flick(text("[]deny", src.base_state), src)

/obj/machinery/door/window/create_electronics(var/electronics_type = /obj/item/airlock_electronics)
	electronics = ..()
	return electronics

/obj/machinery/door/window/brigdoor
	name = "secure door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	var/id = null
	maxhealth = 300
	health = 300.0 //Stronger doors for prison (regular window door health is 150)
	pry_mod = 0.65


/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "rightsecure"
	base_state = "rightsecure"
