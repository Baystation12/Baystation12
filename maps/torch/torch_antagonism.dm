//Makes sure we don't get any merchant antags as a balance concern. Can also be used for future Torch specific antag restrictions.
/datum/antagonist/changeling
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant, /datum/job/captain, /datum/job/hop)

/datum/antagonist/godcultist
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/chaplain, /datum/job/merchant, /datum/job/captain, /datum/job/hop, /datum/job/hos)

/datum/antagonist/cultist
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/chaplain, /datum/job/psychiatrist, /datum/job/merchant, /datum/job/captain, /datum/job/hop, /datum/job/hos)

/datum/antagonist/loyalists
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant)

/datum/antagonist/revolutionary
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant)

/datum/antagonist/traitor
	blacklisted_jobs = list(/datum/job/merchant, /datum/job/captain, /datum/job/hop)

/datum/antagonist/ert
	outfit_type = /decl/hierarchy/outfit/job/torch/ert
	leader_outfit_type = /decl/hierarchy/outfit/job/torch/ert/leader

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)
	player.char_branch = mil_branches.get_branch("Fleet")
	if(player.mind == leader)
		player.char_rank = mil_branches.get_rank("Fleet", "Lieutenant")
	else
		switch(rand(1,2))
			if(1)
				player.char_rank = mil_branches.get_rank("Fleet", "Petty Officer Second Class")
			if(2)
				player.char_rank = mil_branches.get_rank("Fleet", "Petty Officer First Class")
	..()