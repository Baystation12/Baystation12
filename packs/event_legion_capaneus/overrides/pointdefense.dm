/obj/machinery/pointdefense/event_hacked()
	if (GLOB.event_helm_disabled)
		Deactivate()
	else
		Activate()


/obj/machinery/pointdefense_control/CanUseTopic(mob/user)
	if (!GLOB.event_helm_disabled)
		return ..()
	event_notify_hacked(src, user)
	return STATUS_CLOSE


/obj/machinery/pointdefense_control/CanUseTopicPhysical(mob/user)
	if (!GLOB.event_helm_disabled)
		return ..()
	event_notify_hacked(src, user)
	return STATUS_CLOSE


/obj/machinery/pointdefense/Initialize()
	. = ..()

	if (GLOB.event_helm_disabled)
		Deactivate()
