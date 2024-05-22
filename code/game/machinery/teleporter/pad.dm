/obj/machinery/tele_pad
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "pad"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 2000
	light_color = "#02d1c7"

	var/obj/machinery/computer/teleporter/computer

	///Has a high chance to teleport the user to a semi random location when TRUE.
	var/interference = FALSE
	///Chance (0 - 100%) to send a teleported object to The Interlude.
	var/interlude_chance = 0

/obj/machinery/tele_pad/Destroy()
	if (computer)
		computer.lost_pad()
	clear_computer()
	. = ..()


/obj/machinery/tele_pad/proc/clear_computer()
	if (!computer)
		return
	GLOB.destroyed_event.unregister(computer, src, TYPE_PROC_REF(/obj/machinery/tele_pad, lost_computer))
	computer = null


/obj/machinery/tele_pad/proc/lost_computer()
	clear_computer()
	queue_icon_update()


/obj/machinery/tele_pad/proc/set_computer(obj/machinery/computer/teleporter/_computer)
	if (computer == _computer)
		return
	clear_computer()
	computer = _computer
	GLOB.destroyed_event.register(computer, src, TYPE_PROC_REF(/obj/machinery/tele_pad, lost_computer))


/obj/machinery/tele_pad/Bumped(atom/movable/AM)
	if (!computer?.active)
		return
	var/turf/T = get_turf(computer.target)
	if (!T)
		return
	use_power_oneoff(5000)
	if (istype(computer.target, /obj/machinery/tele_beacon))
		var/obj/machinery/tele_beacon = computer.target
		tele_beacon.use_power_oneoff(1 KILOWATTS)

	if (prob(interlude_chance))
		GLOB.using_map.do_interlude_teleport(AM, T, rand(30, 120))
		computer.set_timer()
		return

	if (interference && prob(75))
		do_unstable_teleport_safe(AM)
	else
		do_teleport(AM, T)
	computer.set_timer()


/obj/machinery/tele_pad/attack_ghost(mob/user)
	if (!computer?.active)
		return
	var/turf/T = get_turf(computer.target)
	if (!T)
		return
	user.forceMove(T)


/obj/machinery/tele_pad/power_change()
	. = ..()
	if (!.)
		return
	queue_icon_update()


/obj/machinery/tele_pad/on_update_icon()
	ClearOverlays()
	if (computer?.active)
		update_use_power(POWER_USE_ACTIVE)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		AddOverlays(I)
		set_light(4, 0.4)

		if (interference && prob(20))
			visible_message(SPAN_WARNING("The teleporter sparks ominously!"))
			sparks(3, 1, loc)
	else
		set_light(0)
		update_use_power(POWER_USE_IDLE)
		if (operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			AddOverlays(I)
