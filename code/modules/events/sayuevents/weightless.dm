/datum/event/weightless
	startWhen = 5
	endWhen = 65

/datum/event/weightless/setup()
	startWhen = rand(0,10)
	endWhen = rand(40,80)

/datum/event/weightless/announce()
	command_alert("Warning: Failsafes for the station's artificial gravity arrays have been triggered. Please be aware that if this problem recurs it may result in formation of gravitational anomalies. Nanotrasen wishes to remind you that the unauthorised formation of anomalies within Nanotrasen facilities is strictly prohibited by health and safety regulation [rand(99,9999)][pick("a","b","c")]:subclause[rand(1,20)][pick("a","b","c")].")

/datum/event/weightless/start()
	for(var/area/A in world)
		if (A.z != 1) continue	//Don't turn off gravity on non-station z-levels.
		A.gravitychange(0,A)
/*
	if(control)
		control.weight *= 2
*/
/datum/event/weightless/end()
	for(var/area/A in world)
		if (A.z != 1) continue
		A.gravitychange(1,A)

	if(announceWhen >= 0)
		command_alert("Artificial gravity arrays are now functioning within normal parameters. Please report any irregularities to your respective head of staff.")


