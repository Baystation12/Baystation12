SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE | SS_NEEDS_SHUTDOWN
	var/list/tracking_values = list()
	var/list/persistence_datums = list()


/datum/controller/subsystem/persistence/UpdateStat(time)
	return


/datum/controller/subsystem/persistence/Initialize(start_uptime)
	for(var/thing in subtypesof(/datum/persistent))
		var/datum/persistent/P = new thing
		persistence_datums[thing] = P
		P.Initialize()

/datum/controller/subsystem/persistence/Shutdown()
	for(var/thing in persistence_datums)
		var/datum/persistent/P = persistence_datums[thing]
		P.Shutdown()

/datum/controller/subsystem/persistence/proc/track_value(var/atom/value, var/track_type)

	var/turf/T = get_turf(value)
	if(!T)
		return

	var/area/A = get_area(T)
	if(!A || (A.area_flags & AREA_FLAG_IS_NOT_PERSISTENT))
		return

	if(!(T.z in GLOB.using_map.station_levels) || !initialized)
		return

	if(!tracking_values[track_type])
		tracking_values[track_type] = list()
	tracking_values[track_type] += value

/datum/controller/subsystem/persistence/proc/forget_value(var/atom/value, var/track_type)
	if(tracking_values[track_type])
		tracking_values[track_type] -= value

/datum/controller/subsystem/persistence/proc/show_info(var/mob/user)

	if(!check_rights(R_INVESTIGATE, C = user))
		return

	var/list/dat = list("<table width = '100%'>")
	var/can_modify = check_rights(R_ADMIN, 0, user)
	for(var/thing in persistence_datums)
		var/datum/persistent/P = persistence_datums[thing]
		if(P.has_admin_data)
			dat += P.GetAdminSummary(user, can_modify)
	dat += "</table>"
	var/datum/browser/popup = new(user, "admin_persistence", "Persistence Data")
	popup.set_content(jointext(dat, null))
	popup.open()
