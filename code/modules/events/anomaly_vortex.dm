/datum/event/anomaly_vortex
	startWhen = 10
	announceWhen = 3
	endWhen = 80
	var/area/impact_area
	var/obj/effect/anomaly/newAnomaly

/datum/event/anomaly_vortex/setup()
	impact_area = findEventArea()

/datum/event/anomaly_vortex/announce()
	command_alert("Localized high-intensity vortex anomaly detected on long range scanners. Expected location: [impact_area.name]", "Anomaly Alert")

/datum/event/anomaly_vortex/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/bhole(T.loc)

/datum/event/anomaly_vortex/tick()
	if(!newAnomaly)
		kill()
		return
	newAnomaly.anomalyEffect()

/datum/event/anomaly_vortex/end()
	if(newAnomaly)//Kill the anomaly if it still exists at the end.
		del(newAnomaly)