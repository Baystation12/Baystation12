/obj/machinery/computer/ship/helm/event_hacked()
	if (!linked || !(linked.name in GLOB.event_helm_disabled))
		return

	if (GLOB.event_helm_disabled)
		if (linked.speed["x"] || linked.speed["y"])
			visible_message(SPAN_WARNING("\The [src]'s autopilot suddenly engages, bringing \the [linked] to a stop!"))
			autopilot = TRUE
			set_operator(null, autopilot = TRUE)
		visible_message(SPAN_WARNING("\The [src] buzzes, \"[linked.name] control lost.\""))
	else
		visible_message(SPAN_NOTICE("\The [src] pings, \"[linked.name] control regained.\""))


/obj/machinery/computer/ship/helm/CanUseTopic(mob/user)
	if (!GLOB.event_helm_disabled)
		return ..()
	event_notify_hacked(src, user)
	return STATUS_CLOSE


/obj/machinery/computer/ship/helm/CanUseTopicPhysical(mob/user)
	if (!GLOB.event_helm_disabled)
		return ..()
	event_notify_hacked(src, user)
	return STATUS_CLOSE


/obj/machinery/computer/ship/helm/Process()
	if (!GLOB.event_helm_disabled || !linked ||  !(linked.name in GLOB.event_helm_disabled_ships) || !autopilot || linked.is_still())
		return ..()

	// It wants to stop, not go back to wherever it was when this started.
	if (linked.x != dx)
		dx = linked.x
	if (linked.y != dy)
		dy = linked.y

	return ..()
