/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(
		TECH_ESOTERIC = 2
	)

	var/datum/wires/explosive/c4/wires
	/// Integer. The time, in seconds, the C4's timer is set to.
	var/timer = 10
	/// The atom the C4 is attached to.
	var/atom/target
	/// Boolean. Whether or not the C4's panel is open.
	var/open_panel = FALSE
	/// The generated image overlay used to display the C4 on `target`.
	var/image_overlay
	/// List of atom paths the C4 can be planted on.
	var/list/valid_targets = list(
		/turf/simulated/wall,
		/obj/structure,
		/obj/machinery/door
	)


/obj/item/plastique/Initialize()
	. = ..()
	wires = new(src)
	image_overlay = image('icons/obj/assemblies.dmi', "plastic-explosive2")


/obj/item/plastique/Destroy()
	QDEL_NULL(wires)
	target = null
	return ..()


/obj/item/plastique/attackby(obj/item/I, mob/user)
	if(isScrewdriver(I))
		open_panel = !open_panel
		to_chat(user, "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>")
	else if(isWirecutter(I) || isMultitool(I) || istype(I, /obj/item/device/assembly/signaler ))
		wires.Interact(user)
	else
		..()


/obj/item/plastique/attack_self(mob/user)
	var/newtime = input(usr, "Please set the timer (Seconds).", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = clamp(newtime, 10, 60000)
		timer = newtime
		to_chat(user, "Timer set for [time_to_readable(timer * 10)].")


/obj/item/plastique/afterattack(atom/movable/target, mob/user, flag)
	if (!flag)
		return
	if (!is_type_in_list(target, valid_targets))
		to_chat(user, SPAN_WARNING("\The [src] cannot be planted on \the [target]"))
		return
	user.visible_message(
		SPAN_DANGER("\The [user] starts planting \a [src] on \the [target]!"),
		SPAN_WARNING("You start planting \the [src] on \the [target]!")
	)
	user.do_attack_animation(target)

	if(do_after(user, 5 SECONDS, target, DO_DEFAULT | DO_USER_UNIQUE_ACT) && in_range(user, target))
		if(!user.unequip_item())
			return
		src.target = target
		var/timer_readable = time_to_readable(timer * 10)
		forceMove(target)
		log_and_message_admins("planted \a [src] with a [timer_readable] fuse on \the [target].")
		target.overlays += image_overlay
		user.visible_message(
			SPAN_DANGER("\The [user] plants \a [src] on \the [target]!"),
			SPAN_WARNING("You plant \the [src] on \the [target]. Timer counting down from [timer_readable].")
		)
		run_timer()


/**
 * Detonates the C4 on its current turf or, if defined, `target`.
 *
 * **Parameters**:
 * - `location` - An additional location to call `explosion()` on. Does not affect additional C4 processing on `target`.
 */
/obj/item/plastique/proc/explode(location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)

	if(target)
		target.c4_act()
	if(target)
		target.overlays -= image_overlay
	qdel(src)


/**
 * Continually loops for `timer` seconds, beeping every second, until the counter hits `0`, then calls `explode()`.
 */
/obj/item/plastique/proc/run_timer()
	set waitfor = FALSE
	var/T = timer
	while(T > 0)
		sleep(1 SECOND)
		if(target)
			playsound(target, 'sound/items/timer.ogg', 50)
		else
			playsound(loc, 'sound/items/timer.ogg', 50)
		T--
	explode(get_turf(target))


/obj/item/plastique/attack(mob/M, mob/user, def_zone)
	return


/// Called when C4 explodes on the atom. By default, this calls `ex_act()`
/atom/proc/c4_act()
	ex_act(EX_ACT_DEVASTATING)


/turf/simulated/wall/c4_act()
	kill_health() // Still leaves behind girders


/mob/c4_act()
	ex_act(EX_ACT_HEAVY) // Less likely to instagib
