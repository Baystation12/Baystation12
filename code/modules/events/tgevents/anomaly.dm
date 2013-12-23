/datum/event/anomaly

	var/obj/effect/anomaly/newAnomaly


/datum/event/anomaly/setup()
	impact_area = findEventArea()
	testing("[impact_area]")

/datum/event/anomaly/announce()
	command_alert("Localized hyper-energetic flux wave detected on long range scanners. Expected location of impact: [impact_area.name].", "Anomaly Alert")

/datum/event/anomaly/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T.loc)

/datum/event/anomaly/tick()
	if(!newAnomaly)
		kill()
		return
	newAnomaly.anomalyEffect()

/datum/event/anomaly/end()
	if(newAnomaly)//Kill the anomaly if it still exists at the end.
		del(newAnomaly)