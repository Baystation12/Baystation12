#define SHUNT_STATE_LOCKED          1
#define SHUNT_STATE_PANEL_OPEN      2
#define SHUNT_STATE_PANEL_UNSCREWED 4
#define SHUNT_STATE_ADJUSTED        8
#define SHUNT_STATE_PRIMED         16
#define TC_SABOTAGE_COST           25

GLOBAL_LIST_INIT(bluespace_drives, list())
GLOBAL_VAR_INIT(bluespace_drive_collapsing, 0)

// Get the first, least sabotaged, functional bluespace core on the station map.
/proc/get_best_bluespace_drive(var/check_z)
	var/list/checking_z = GetConnectedZlevels(check_z)
	var/list/valid_drives = list()
	for(var/thing in GLOB.bluespace_drives)
		var/obj/machinery/drive_core/drive = thing
		if((drive.z in checking_z) && drive.is_functional())
			valid_drives += drive
	if(valid_drives.len)
		var/obj/machinery/drive_core/lowest_sabotaged_drive
		for(var/thing in valid_drives)
			var/obj/machinery/drive_core/drive = thing
			if(!lowest_sabotaged_drive || lowest_sabotaged_drive.is_sabotaged() > drive.is_sabotaged())
				lowest_sabotaged_drive = drive
		return lowest_sabotaged_drive