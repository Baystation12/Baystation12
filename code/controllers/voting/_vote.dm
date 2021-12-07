GLOBAL_VAR_INIT(last_player_vote, 0)

/datum/vote
	var/name
	var/list/voting = list()
	var/list/choices = list()			//list of options which index the total tally for each option
										//note that the score given to the tally might not equal the exact weight - some players vote has more weight than others!
	var/list/choices_weights = list()	//list of options which index a list of ckeys voting for that option then each ckey indexes its vote weight
	var/list/additional_text = list()
	var/additional_text_title
	var/initiator = null
	var/question = null
	var/status_quo //If set, we will return this answer if noone votes.
	var/started_time = null
	var/time_remaining = 0
	var/total_votes = 0
	var/hidden = 0
	var/round_start_hidden = 0
	var/disabled = 0
	var/disable_reason = null
	var/announce_ogg = 'sound/ambience/alarm4.ogg'
	var/delay_round_start = 0
	var/delay_round_end = 0
	var/active = 0
	var/last_process = 0
	var/delayed = 0

/datum/vote/proc/Initialize()
	. = ..()
	reset()

/datum/vote/proc/reset()
	initiator = null
	time_remaining = 0
	question = null

	reset_choices()

/datum/vote/proc/reset_choices()
	for(var/option in choices)
		choices[option] = 0
		choices_weights[option] = list()
