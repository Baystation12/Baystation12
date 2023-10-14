/datum/ai_holder/alien
	holder_required_type = /mob/living/carbon/alien
	retaliate = TRUE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 1
	wander = TRUE
	base_wander_delay = 4

/datum/ai_holder/alien/passive
	retaliate = FALSE
	can_flee = TRUE
	flee_from_allies = TRUE
	violent_breakthrough = FALSE
