/datum/game_mode/malfunction
	name = "Malfunctioning AI"
	round_description = "The AI is behaving abnormally and must be stopped."
	extended_round_description = "The AI will attempt to hack the APCs in order to gain as much control as possible."
	config_tag = "malfunction"
	required_players = 2
	required_enemies = 1
	end_on_antag_death = FALSE
	auto_recall_shuttle = FALSE
	antag_tags = list(MODE_MALFUNCTION)
	disabled_jobs = list("AI")
	cinematic_icon_states = list(
		"intro_malf" = 76,
		"summary_malf",
		null
	)

/datum/game_mode/malfunction/post_setup()
	. = ..()
	var/mob/living/silicon/ai/master

	for(var/mob/living/silicon/ai/ai in GLOB.player_list)
		if(ai.check_special_role("Malfunctioning AI"))
			master = ai
			break

	if(!master)
		return

	for(var/mob/living/silicon/robot/R in GLOB.player_list)
		if(R.connected_ai)
			continue
		R.connect_to_ai(master)
		R.lawupdate = TRUE
		R.sync()
