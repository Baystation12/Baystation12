/datum/language/binary
	name = "Robot Talk"
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = "states"
	ask_verb = "queries"
	exclaim_verb = "declares"
	key = "b"
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/observer/virtual/v, var/datum/communication/c)
	if(!v.host.binarycheck())
		return

	for (var/mob/M in dead_mob_list_)
		if(isghost(M))
			M.hear(c)

	for (var/mob/living/S in living_mob_list_)
		if(drone_only && !istype(S,/mob/living/silicon/robot/drone))
			continue
		else if (!S.binarycheck())
			continue
		S.hear(c)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(istype(M, /mob/living/silicon) || M.binarycheck())
			continue
		M.hear("<i><span class='game say'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>")

	//robot binary xmitter component power usage
	if (isrobot(v.host))
		var/mob/living/silicon/robot/R = v.host
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = "Drone Talk"
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = 1
