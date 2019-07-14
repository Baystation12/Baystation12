/obj/machinery/drive_core
	var/global/list/drive_failures = list(
		list(/decl/drive_failure/minor),
		list(/decl/drive_failure/moderate),
		list(/decl/drive_failure/major)
	)

/obj/machinery/drive_core/proc/is_sabotaged()
	. = 0
	for(var/obj/machinery/power/shunt/shunt in shunts)
		if(shunt.shunt_state & SHUNT_STATE_PRIMED)
			.++
