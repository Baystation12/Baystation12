/obj/machinery/teleport/station
	name = "projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon_state = "station"
	var/engaged = FALSE
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/machinery/computer/teleporter/com
	var/obj/machinery/teleport/hub/hub

/obj/machinery/teleport/station/Initialize()
	. = ..()
	for (var/target_dir in GLOB.cardinal)
		var/obj/machinery/teleport/hub/found_pad = locate() in get_step(src, target_dir)
		if(found_pad)
			set_dir(get_dir(src, found_pad))
			break
	queue_icon_update()

/obj/machinery/teleport/station/on_update_icon()
	. = ..()
	overlays.Cut()
	if (engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I
	else if (operable())
		var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER
		overlays += I

/obj/machinery/teleport/station/attackby(var/obj/item/W, var/mob/user)
	attack_hand(user)

/obj/machinery/teleport/station/interface_interact(var/mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(engaged)
		disengage()
	else
		engage()
	return TRUE

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	if (!(com && com.locked))
		audible_message("<span class='warning'>Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix.</span>")
		return

	if(istype(com.locked, /obj/item/device/radio/beacon))
		var/obj/item/device/radio/beacon/B = com.locked
		if(!B.functioning)
			audible_message("<span class='warning'>Failure: Unable to establish connection to provided coordinates. Please reinstate coordinate matrix.</span>")
			return

	engaged = TRUE
	queue_icon_update()
	if (hub)
		hub.queue_icon_update()
		use_power_oneoff(5000)
		update_use_power(POWER_USE_ACTIVE)
		hub.update_use_power(POWER_USE_ACTIVE)
		audible_message("<span class='notice'>Teleporter engaged!</span>")
	return

/obj/machinery/teleport/station/proc/disengage()
	if(stat & BROKEN)
		return

	engaged = FALSE
	queue_icon_update()
	if (hub)
		hub.queue_icon_update()
		hub.update_use_power(POWER_USE_IDLE)
		update_use_power(POWER_USE_IDLE)
		audible_message("<span class='notice'>Teleporter disengaged!</span>")
	return

/obj/machinery/teleport/station/Destroy()
	disengage()
	com = null
	hub = null
	return ..()

/obj/machinery/teleport/station/power_change()
	. = ..()
	if (engaged && (stat & NOPOWER))
		disengage()
