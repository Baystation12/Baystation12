/datum/event/anomaly_flux
	startWhen = 3
	announceWhen = 20
	endWhen = 60
	var/area/impact_area
	var/obj/effect/anomaly/newAnomaly

/datum/event/anomaly_flux/setup()
	impact_area = findEventArea()

/datum/event/anomaly_flux/announce()
	command_alert("Localized hyper-energetic flux wave detected on long range scanners. Expected location: [impact_area.name].", "Anomaly Alert")

/datum/event/anomaly_flux/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T.loc)

/datum/event/anomaly_flux/tick()
	if(!newAnomaly)
		kill()
		return
	newAnomaly.anomalyEffect()

/datum/event/anomaly_flux/end()
	if(newAnomaly)//If it hasn't been neutralized, it's time to blow up.
		explosion(newAnomaly.loc, 3, 5, 5)
		del(newAnomaly)