// Events are sent to the program by the computer.
// Always include a parent call when overriding an event.

// Called when the ID card is removed from computer. ID is removed AFTER this proc.
/datum/computer_file/program/proc/event_idremoved(var/background)
	return

// Called when the computer fails due to power loss. Override when program wants to specifically react to power loss.
/datum/computer_file/program/proc/event_powerfailure(var/background)
	kill_program(1)

// Called when the network connectivity fails. Computer does necessary checks and only calls this when requires_ntnet_feature and similar variables are not met.
/datum/computer_file/program/proc/event_networkfailure(var/background)
	kill_program(1)
	if(background)
		computer.visible_message("<span class='warning'>\The [computer]'s screen displays an error: \"Network connectivity lost - process [filename].[filetype] (PID [rand(100,999)]) terminated.\"</span>", range = 1)
	else
		computer.visible_message("<span class='warning'>\The [computer]'s screen briefly freezes and then shows: \"FATAL NETWORK ERROR - NTNet connection lost. Please try again later. If problem persists, please contact your system administrator.\"</span>", range = 1)
		computer.update_icon()