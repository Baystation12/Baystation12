/datum/event/anomaly_grav
	startWhen = 3
	announceWhen = 20
	endWhen = 50
	var/area/impact_area
	var/obj/effect/anomaly/newAnomaly

/datum/event/anomaly_grav/setup()
	impact_area = findEventArea()

/datum/event/anomaly_grav/announce()
	command_alert("Gravitational anomaly detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")

/datum/event/anomaly_grav/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/grav(T.loc)

/datum/event/anomaly_grav/tick()
	if(!newAnomaly)
		kill()
		return
	newAnomaly.anomalyEffect()

/datum/event/anomaly_grav/end()
	if(newAnomaly)//Kill the anomaly if it still exists at the end.
		del(newAnomaly)