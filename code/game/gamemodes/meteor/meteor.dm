// The following four defines can be used to tweak the difficulty of the gamemode
#define METEOR_FAILSAFE_THRESHOLD 45 MINUTES	// Failsafe that guarantees Severity will be at least 15 when the round hits this time.

// In general, a PVE oriented game mode. A middle ground between Extended and actual antagonist based rounds.
/datum/game_mode/meteor
	name = "Meteor"
	round_description = "You are about to enter an asteroid belt!"
	extended_round_description = "We are on an unavoidable collision course with an asteroid field. You have only a moment to prepare before you are barraged by dust and meteors. As if it was not enough, all kinds of negative events seem to happen more frequently. Good Luck."
	config_tag = "meteor"
	required_players = 15				// Definitely not good for low-pop
	votable = 1
	shuttle_delay = 2
	var/next_wave = INFINITY			// Set in post_setup() correctly to take into account potential longer pre-start times.
	var/alert_sent = 0
	var/meteor_severity = 1				// Slowly increases the tension at the beginning of meteor strikes. Prevents "tunguska on first wave" style problems.
	var/failsafe_triggered = 0
	var/alert_title
	var/alert_text
	var/start_text
	var/maximal_severity = 40
	var/meteor_wave_delay = 30 SECONDS //minimum wait between waves in tenths of seconds
	var/meteor_grace_period = 15 MINUTES //waves will not arrive until this far into round

	// Moved these from defines to variables, to allow for in-round tweaking via varedit:
	var/escalation_probability = 45
	var/send_admin_broadcasts = TRUE	// Enables debugging/information mode, sending admin messages when waves occur and when severity escalates.

	event_delay_mod_moderate = 0.5		// As a bonus, more frequent events.
	event_delay_mod_major = 0.3

/decl/vv_set_handler/meteor_severity_handler
	handled_type = /datum/game_mode/meteor
	handled_vars = list(
		"meteor_severity" = /datum/game_mode/meteor/proc/set_meteor_severity,
		"meteor_wave_delay" = /datum/game_mode/meteor/proc/set_meteor_wave_delay
	)

/datum/game_mode/meteor/proc/set_meteor_severity(value)
	meteor_severity = Clamp(value, 0, maximal_severity)

/datum/game_mode/meteor/proc/set_meteor_wave_delay(value)
	meteor_wave_delay = max(10 SECONDS, value)

/datum/game_mode/meteor/VV_static()
	return ..() + "maximal_severity"

/datum/game_mode/meteor/post_setup()
	..()
	alert_title = "Automated Beacon AB-[rand(10, 99)]"
	alert_text = "This is an automatic warning. Your facility: [GLOB.using_map.full_name] is on a collision course with a nearby asteroid belt. Estimated time until impact is: [meteor_grace_period / 1200] MINUTES. Please perform necessary actions to secure your ship or station from the threat. Have a nice day."
	start_text = "This is an automatic warning. Your facility: [GLOB.using_map.full_name] has entered an asteroid belt. Estimated time until you leave the belt is: [rand(20,30)] HOURS and [rand(1, 59)] MINUTES. For your safety, please consider changing course or using protective equipment. Have a nice day."
	next_wave = round_duration_in_ticks + meteor_grace_period

/datum/game_mode/meteor/proc/on_meteor_warn()
	alert_sent = 1
	command_announcement.Announce(alert_text, alert_title)

/datum/game_mode/meteor/proc/on_enter_field()
	alert_sent = 2
	command_announcement.Announce(start_text, alert_title)
	for(var/obj/machinery/shield_diffuser/SD in SSmachines.machinery)
		SD.meteor_alarm(INFINITY)
	if(GLOB.using_map.use_overmap)
		var/area/map = locate(/area/overmap)
		for(var/turf/T in map)
			T.overlays += image('icons/obj/overmap.dmi', "meteor[rand(1,4)]")
	next_wave = round_duration_in_ticks + meteor_wave_delay

/datum/game_mode/meteor/process()
	// Send an alert halfway through the round.
	if((round_duration_in_ticks >= (next_wave / 2)) && !alert_sent)
		on_meteor_warn()
	// And then another one when the meteors start flying around.
	if((round_duration_in_ticks >= next_wave) && (alert_sent == 1))
		on_enter_field()
	if((round_duration_in_ticks >= METEOR_FAILSAFE_THRESHOLD) && (meteor_severity < 15) && !failsafe_triggered)
		log_and_message_admins("Meteor mode severity failsafe triggered: Severity forced to 15.")
		meteor_severity = 15
		failsafe_triggered = 1

	if(round_duration_in_ticks >= next_wave)
		next_wave = round_duration_in_ticks + meteor_wave_delay
		// Starts as barely noticeable dust impact, ends as barrage of most severe meteor types the code has to offer. Have fun.
		spawn()
			spawn_meteors(meteor_severity, get_meteor_types(), pick(GLOB.cardinal), pick(GLOB.using_map.station_levels))
		var/escalated = FALSE
		if(prob(escalation_probability) && (meteor_severity < maximal_severity))
			meteor_severity++
			escalated = TRUE
		if(send_admin_broadcasts)
			log_and_message_admins("Meteor: Wave fired. Escalation: [escalated ? "Yes" : "No"]. Severity: [meteor_severity]/[maximal_severity]")

/datum/game_mode/meteor/proc/get_meteor_types()
	switch(meteor_severity)
		if(1 to 9)
			return meteors_dust
		if(10 to 19)
			return meteors_normal
		if(20 to 29)
			return meteors_threatening
		if(30 to 34)
			return meteors_catastrophic
		if(35 to 39)
			return meteors_armageddon
		if(40 to INFINITY)
			return meteors_cataclysm
	// Just in case we /somehow/ get here (looking at you, varedit)
	return meteors_normal


#undef METEOR_FAILSAFE_THRESHOLD
