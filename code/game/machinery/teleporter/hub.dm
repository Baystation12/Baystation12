/obj/machinery/teleport/hub
	name = "teleporter pad"
	desc = "The teleporter pad handles all of the impossibly complex busywork required in instant matter transmission."
	icon_state = "pad"
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/machinery/computer/teleporter/com
	var/obj/machinery/teleport/beacon/beacon
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
		disconnect_beacon()
		queue_icon_update()
	return

/obj/machinery/teleport/hub/proc/connect_beacon(obj/machinery/teleport/beacon/B)
	if (beacon)
		disconnect_beacon()

	beacon = B
	B.connect_hub(src)

/obj/machinery/teleport/hub/proc/disconnect_beacon()
	if (beacon)
		var/obj/machinery/teleport/beacon/B = beacon
		beacon = null
		B.disconnect_hub(src)

	if (com)
		if (com.station?.engaged)
			com.station.disengage()
		com.locked = null

/obj/machinery/teleport/hub/Destroy()
	disconnect_beacon()

	if (com)
		if (com.station?.hub == src)
			com.station.disengage()
			com.station.hub = null
		com.hub = null
		com = null

	return ..()
