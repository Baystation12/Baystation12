var/datum/antagonist/onioperative/operative

/datum/antagonist/onioperative
	id = MODE_ACHLYS
	role_text = "Section 3 Operative"
	welcome_text = "Anyone that sets foot on the Achlys cannot leave it alive. You know what must be done."
	protected_jobs = list(/datum/job/achlys/sangheili, /datum/job/achlys/prisoner, /datum/job/achlys/SL, /datum/job/achlys/CO)
	hard_cap = 6
	hard_cap_round = 6
	initial_spawn_req = 0
	initial_spawn_target = 6