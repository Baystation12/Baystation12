GLOBAL_DATUM_INIT(chorus, /datum/antagonist/chorus, new)

/datum/antagonist/chorus
	id = MODE_DEITY
	role_text = "Chorus"
	role_text_plural = "Chorus"
	mob_path = /mob/living/chorus
	welcome_text = "You are a parasitic being whose sole purpose is to grow and enthrall others to help you. Keep yourself hidden while expanding your influence."
	landmark_id = "Observer-Start"

	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB

	hard_cap = 2
	hard_cap_round = 2
	initial_spawn_req = 1
	initial_spawn_target = 1


/datum/antagonist/chorus/print_player_summary()
	for(var/datum/mind/player in current_antagonists)
		if(!player?.current || player?.current.stat)
			continue
		var/mob/living/chorus/C = player.current
		C.print_end_game_screen()