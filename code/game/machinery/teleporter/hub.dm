/obj/machinery/teleport/hub
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon_state = "pad"
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/machinery/computer/teleporter/com
	light_color = "#02d1c7"

/obj/machinery/teleport/hub/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/teleport/hub/LateInitialize()
	. = ..()
	queue_icon_update()

/obj/machinery/teleport/hub/on_update_icon()
	overlays.Cut()
	if (com?.station?.engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
		set_light(0.4, 1.2, 4, 10)
	else
		set_light(0)
		if (operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER
			overlays += I

/obj/machinery/teleport/hub/Bumped(M as mob|obj)
	if (com?.station?.engaged)
		teleport(M)
		use_power_oneoff(5000)

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj)
	if (!com)
		return
	do_teleport(M, com.locked)
	if(com.one_time_use) //Make one-time-use cards only usable one time!
		com.one_time_use = FALSE
		com.locked = null
		if (com.station)
			com.station.engaged = FALSE
		queue_icon_update()
	return

/obj/machinery/teleport/hub/Destroy()
	com = null
	return ..()
