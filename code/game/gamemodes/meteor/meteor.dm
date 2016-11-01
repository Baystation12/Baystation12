#define METEOR_DELAY 30 MINUTES			// This should be enough for crew to set up.
#define METEOR_DELAY_MULTIPLIER 5		// 5x larger duration between waves. That ensures the mode is less of a instant destruction of the station, and more of a continous stress.
// In general, a PVE oriented game mode. A middle ground between Extended and actual antagonist based rounds.
/datum/game_mode/meteor
	name = "Meteor"
	round_description = "The space station is about to enter an asteroid belt!"
	extended_round_description = "The station is on an unavoidable collision course with an asteroid field. You have only a moment to prepare before the station is barraged by dust and meteors. As if it was not enough, all kinds of negative events seem to happen more frequently. Good Luck."
	config_tag = "meteor"
	required_players = 5				// Definitely not good for low-pop
	votable = 1
	var/next_wave = INFINITY			// Set in post_setup() correctly to take into account potential longer pre-start times.
	var/alert_sent = 0
	var/meteor_severity = 1				// Slowly increases the tension at the beginning of meteor strikes. Prevents "tunguska on first wave" style problems.
	var/alert_title
	var/alert_text
	var/start_text

	event_delay_mod_moderate = 0.5		// As a bonus, more frequent events.
	event_delay_mod_major = 0.5

/datum/game_mode/meteor/post_setup()
	..()
	alert_title = "Automated Beacon AB-[rand(10, 99)]"
	alert_text = "This is an automatic warning. Your facility: [using_map.full_name] is on a collision course with a nearby asteroid belt. Estimated time until impact is: [METEOR_DELAY / 240] MINUTES. Please perform necessary actions to secure your ship or station from the threat. Have a nice day."
	start_text = "This is an automatic warning. Your facility: [using_map.full_name] has entered an asteroid belt. For your safety, please consider changing course or using protective equipment. Have a nice day."
	next_wave = round_duration_in_ticks + METEOR_DELAY

/datum/game_mode/meteor/process()
	// Send an alert halfway through the round.
	if((round_duration_in_ticks >= (next_wave / 2)) && !alert_sent)
		alert_sent = 1
		command_announcement.Announce(alert_text, alert_title)
	// And then another one when the meteors start flying around.
	if((round_duration_in_ticks >= next_wave) && (alert_sent == 1))
		alert_sent = 2
		command_announcement.Announce(start_text, alert_title)

	if(round_duration_in_ticks >= next_wave)
		next_wave = round_duration_in_ticks + (meteor_wave_delay * METEOR_DELAY_MULTIPLIER)
		// Starts as barely noticeable dust impact, ends as barrage of most severe meteor types the code has to offer. Have fun.
		spawn()
			spawn_meteors(meteor_severity, get_meteor_types(), pick(cardinal))
		if(prob(25))
			meteor_severity = min(meteor_severity + 1, 10)

/datum/game_mode/meteor/proc/get_meteor_types()
	switch(meteor_severity)
		if(1 to 3)
			return meteors_dust
		if(4 to 6)
			return meteors_normal
		if(7 to 9)
			return meteors_threatening
		if(10)
			return meteors_catastrophic
	// Just in case we /somehow/ get here (looking at you, varedit)
	return meteors_normal


#undef METEOR_DELAY
#undef METEOR_DELAY_MULTIPLIER
