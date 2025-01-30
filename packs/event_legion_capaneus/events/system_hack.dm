/// When set, globally disables the Torch's helm controls.
GLOBAL_VAR_INIT(event_helm_disabled)
GLOBAL_LIST_AS(event_helm_disabled_ships, list("SEV Torch", "Charon", "Guppy", "Aquila"))
GLOBAL_LIST_AS(event_machine_types_to_hack, list(\
	/obj/machinery/computer/ship/helm,\
	/obj/machinery/power/shield_generator,\
	/obj/machinery/pointdefense_control\
))

/// Proc called when the event's hacked state toggles.
/atom/proc/event_hacked()
	return


/proc/event_notify_hacked(atom/object, mob/user)
	set waitfor = FALSE
	alert(user, "\The [object]'s controls are not responding.", object.name)


/proc/event_system_hack()
	message_admins("Hack starting now.")
	GLOB.event_helm_disabled = TRUE

	for (var/obj/machinery/machine as anything in SSmachines.machinery)
		if (!is_type_in_list(machine, GLOB.event_machine_types_to_hack))
			continue
		machine.event_hacked()


/proc/event_end_system_hack()
	message_admins("Hack ending now.")
	GLOB.event_helm_disabled = FALSE

	for (var/obj/machinery/machine as anything in SSmachines.machinery)
		if (!is_type_in_list(machine, GLOB.event_machine_types_to_hack))
			continue
		machine.event_hacked()
