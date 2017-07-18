var/datum/antagonist/deity/deity

/datum/antagonist/deity
	id = MODE_DEITY
	role_text = "Deity"
	role_text_plural = "Deities"
	mob_path = /mob/living/deity
	welcome_text = "This is not your world. This is not your reality. But here you exist. Use your powers, feed off the faith of others."
	landmark_id = "DeitySpawn"

	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB

	hard_cap = 2
	hard_cap_round = 2
	initial_spawn_req = 1
	initial_spawn_target = 1

/datum/antagonist/deity/New()
	..()
	deity = src