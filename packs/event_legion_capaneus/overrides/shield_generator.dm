/obj/machinery/power/shield_generator/event_hacked()
	if (running && GLOB.event_helm_disabled)
		shutdown_field()


/obj/machinery/power/shield_generator/set_idle(new_state)
	if (GLOB.event_helm_disabled)
		return
	..()


/obj/machinery/power/shield_generator/CanUseTopic(mob/user)
	if (!GLOB.event_helm_disabled)
		return ..()
	event_notify_hacked(src, user)
	return STATUS_CLOSE


/obj/machinery/power/shield_generator/CanUseTopicPhysical(mob/user)
	if (!GLOB.event_helm_disabled)
		return ..()
	event_notify_hacked(src, user)
	return STATUS_CLOSE
