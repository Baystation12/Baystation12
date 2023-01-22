/// The name of the controller
/datum/controller
	var/name

	/// The atom used to hold information about the controller for client UI output
	var/atom/movable/clickable_stat/statLine


	/// The next time we should do work updating statLine
	var/statNext = 0


/datum/controller/Destroy(force)
	log_debug({"Controller "[name]" destroyed with force="[force]"!"})
	if (!force)
		return QDEL_HINT_LETMELIVE
	QDEL_NULL(statLine)
	return ..()


/datum/controller/proc/Initialize()
	return


/datum/controller/proc/Shutdown()
	return



/datum/controller/proc/Recover()
	return


/// when we enter dmm_suite.load_map
/datum/controller/proc/StartLoadingMap()
	return

/// when we exit dmm_suite.load_map
/datum/controller/proc/StopLoadingMap()
	return


/datum/controller/proc/UpdateStat(text)
	if (!statLine)
		statLine = new (null, src)
	if (istext(text))
		statLine.name = text
	stat(name, statLine)


/datum/controller/proc/PreventUpdateStat(time)
	if (!isnum(time))
		time = Uptime()
	if (time < statNext)
		return TRUE
	statNext = time + 1 SECONDS
	return FALSE
