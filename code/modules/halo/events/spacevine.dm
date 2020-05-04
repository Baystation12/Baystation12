
/datum/event/ship/spacevines
	title = "Level 5 Biohazard Alert"

/datum/event/ship/spacevines/setup()
	. = ..()
	announceWhen = rand(10,60)
	endWhen = announceWhen + 1
	announce_message = "Confirmed outbreak of level 5 floral biohazard aboard [target_ship]. \
		All personnel must contain the outbreak."

datum/event/ship/spacevines/start()
	spacevine_infestation(get_random_floor(1))
