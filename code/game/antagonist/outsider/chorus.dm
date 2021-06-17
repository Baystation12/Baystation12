GLOBAL_DATUM_INIT(chorus, /datum/antagonist/chorus, new)

/datum/antagonist/chorus
	id = MODE_DEITY
	role_text = "Chorus"
	role_text_plural = "Chorus"
	welcome_text = "You are one of many! Use this vessel as a habitat. Grow the Chorus, and pave the way for new progeny. \
	Speak with any other minds in your Chorus by using chat functions to talk normally."
	landmark_id = "xeno_spawn"

	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB
	mob_path = /mob/living/carbon/alien/chorus

	hard_cap = 10
	hard_cap_round = 10
	initial_spawn_req = 1
	initial_spawn_target = 3
	skill_setter = null // we are a flesh beast and do not use skills
