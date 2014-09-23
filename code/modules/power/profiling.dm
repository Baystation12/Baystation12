datum

var/global/enable_power_update_profiling = 0

var/global/power_profiled_time = 0
var/global/power_last_profile_time = 0
var/global/list/power_update_requests_by_machine = list()
var/global/list/power_update_requests_by_area = list()

/proc/log_power_update_request(area/A, obj/machinery/M)
	if (!enable_power_update_profiling)
		return

	var/machine_type = "[M.type]"
	if (machine_type in power_update_requests_by_machine)
		power_update_requests_by_machine[machine_type] += 1
	else
		power_update_requests_by_machine[machine_type] = 1

	if (A.name in power_update_requests_by_area)
		power_update_requests_by_area[A.name] += 1
	else
		power_update_requests_by_area[A.name] = 1

	power_profiled_time += (world.time - power_last_profile_time)
	power_last_profile_time = world.time

/client/proc/toggle_power_update_profiling()
	set name = "Toggle Area Power Update Profiling"
	set desc = "Toggles the recording of area power update requests."
	set category = "Debug"
	if(!check_rights(R_DEBUG))	return

	if(enable_power_update_profiling)
		enable_power_update_profiling = 0

		usr << "Area power update profiling disabled."
		message_admins("[key_name(src)] toggled area power update profiling off.")
		log_admin("[key_name(src)] toggled area power update profiling off.")
	else
		enable_power_update_profiling = 1
		power_last_profile_time = world.time

		usr << "Area power update profiling enabled."
		message_admins("[key_name(src)] toggled area power update profiling on.")
		log_admin("[key_name(src)] toggled area power update profiling on.")

	feedback_add_details("admin_verb","APUP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/view_power_update_stats_machines()
	set name = "View Area Power Update Statistics By Machines"
	set desc = "See which types of machines are triggering area power updates."
	set category = "Debug"

	if(!check_rights(R_DEBUG))	return

	usr << "Total profiling time: [power_profiled_time] ticks"
	for (var/M in power_update_requests_by_machine)
		usr << "[M] = [power_update_requests_by_machine[M]]"

/client/proc/view_power_update_stats_area()
	set name = "View Area Power Update Statistics By Area"
	set desc = "See which areas are having area power updates."
	set category = "Debug"

	if(!check_rights(R_DEBUG))	return

	usr << "Total profiling time: [power_profiled_time] ticks"
	usr << "Total profiling time: [power_profiled_time] ticks"
	for (var/A in power_update_requests_by_area)
		usr << "[A] = [power_update_requests_by_area[A]]"