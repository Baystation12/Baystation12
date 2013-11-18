/datum/event/anomaly_pyro
	startWhen = 10
	announceWhen = 3
	endWhen = 70
	var/area/impact_area
	var/obj/effect/anomaly/newAnomaly

/datum/event/anomaly_pyro/setup()
	impact_area = findEventArea()

/datum/event/anomaly_pyro/announce()
	command_alert("Atmospheric anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")

/datum/event/anomaly_pyro/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/pyro(T.loc)

/datum/event/anomaly_pyro/tick()
	if(!newAnomaly)
		kill()
		return
	if(IsMultiple(activeFor, 5))
		newAnomaly.anomalyEffect()

/datum/event/anomaly_pyro/end()
	if(newAnomaly)//Kill the anomaly if it still exists at the end.
		del(newAnomaly)
