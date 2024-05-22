//Torch override for it, auto-calls long-delayed jump automatically so round duration is hard capped.
/datum/game_mode/meteor
	name = "Meteor"
	round_description = "Suddenly the rocks, thousands of them!"
	extended_round_description = "We are on an unavoidable collision course with an asteroid field. You have only a moment to prepare before you are barraged by dust and meteors. Emergency BS drive spoolup has been initiated, but you need to survive until it's done."
	shuttle_delay = 5	//40ish minutes round
	meteor_grace_period = 10 MINUTES
	meteor_severity = 10   //Since Torch is pretty sturdy and time is of essence, jumpstart things a bit
	escalation_probability = 70

/datum/game_mode/meteor/post_setup()
	..()
	alert_title = "[GLOB.using_map.full_name] Short Range Sensors"
	alert_text = "[GLOB.using_map.full_name] is on a collision course with an ultradense asteroid field. Estimated time until impact is: [meteor_grace_period / 1200] MINUTES. Emegency random jump procedure initiated."
	start_text = "Asteroid field imminent. All hands brace for multiple impacts. May %DEITY_NAME% be with you."

	GLOB.using_map.shuttle_called_message = "Attention all hands: Emergency Bluespace Drive spool up initiated. It will be ready for jump in %ETA%."
	GLOB.using_map.shuttle_docked_message = "Attention all hands: Bluespace Drive spooled up. Emergency bluespace jump in %ETD%."
	GLOB.using_map.shuttle_leaving_dock = "Attention all hands: Emergency bluespace jump initiated, emerging in %ETA%."

/datum/game_mode/meteor/on_meteor_warn()
	..()
	var/datum/evacuation_option/meteor_bluespace_jump/auto_evac = new()
	auto_evac.execute()

/datum/game_mode/meteor/declare_completion()
	var/eng_status = 0
	for(var/obj/machinery/atmospherics/unary/engine/E as anything in SSmachines.get_machinery_of_type(/obj/machinery/atmospherics/unary/engine))
		if((get_z(E) in GLOB.using_map.station_levels) && !MACHINE_IS_BROKEN(E))
			eng_status++
	var/nav_status = FALSE
	for(var/obj/machinery/computer/ship/helm/H as anything in SSmachines.get_machinery_of_type(/obj/machinery/computer/ship/helm))
		if((get_z(H) in GLOB.using_map.station_levels) && !MACHINE_IS_BROKEN(H))
			nav_status = TRUE
	var/bsd_status = FALSE
	var/area/A = locate(/area/engineering/bluespace) in world
	if(A && A.powered(EQUIP)) //There's no actual machines to check
		bsd_status = TRUE

	to_world("<h3>Damage report</h3>")
	if(eng_status)
		to_world(SPAN_GOOD("At least [eng_status] thrusters remained operational."))
	else
		to_world(SPAN_BAD("All propulsion was lost, leaving \the [GLOB.using_map.full_name] drifting."))
	if(nav_status)
		to_world(SPAN_GOOD("Navigation and helm remained operational."))
	else
		to_world(SPAN_BAD("The navigation systems were lost on [GLOB.using_map.full_name]."))
	if(bsd_status)
		to_world(SPAN_GOOD("Bluespace drive stayed powered."))
	else
		to_world(SPAN_BAD("Bluespace drive lost power during the jump, causing dangerous anomalies in the local time-space."))


//Bluespace jump but ignoring cooldowns and done at roundstart basically
/datum/evacuation_option/meteor_bluespace_jump
	option_text = "Initiate emergency bluespace jump"
	option_desc = "initiate automated emergency bluespace jump"

/datum/evacuation_option/meteor_bluespace_jump/execute(mob/user)
	if (!evacuation_controller)
		return
	evacuation_controller.call_evacuation(user, 0, forced = TRUE)
