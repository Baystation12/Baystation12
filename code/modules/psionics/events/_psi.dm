/datum/event/psi
	startWhen = 30
	endWhen = 120

/datum/event/psi/announce()
	priority_announcement.Announce( \
		"A localized disruption within the neighboring psionic continua has been detected. All psi-operant crewmembers \
		are advised to cease any sensitive activities and report to medical personnel in case of damage.", \
		"Cuchulain Sensor Array Automated Message" \
		)

/datum/event/psi/end()
	priority_announcement.Announce( \
		"The psi-disturbance has ended and baseline normality has been re-asserted. \
		Anything you still can't cope with is therefore your own problem.", \
		"Cuchulain Sensor Array Automated Message" \
	)

/datum/event/psi/tick()
	for(var/thing in SSpsi.processing)
		apply_psi_effect(thing)

/datum/event/psi/proc/apply_psi_effect(var/datum/psi_complexus/psi)
	return
