
/datum/techprint/sangheili_translators
	name = "Sangheili autotranslators"
	desc = "Enough of the language to understand it, but not speak it."
	design_unlocks = list(/datum/research_design/implant_sangheili)
	ticks_max = 120
	tech_req_all = list(\
		/datum/techprint/autopsy/sangheili,\
		/datum/techprint/biology_two)

/datum/techprint/sangheili_learners
	name = "Sangheili language learners"
	desc = "Understand the nuances of Sangheili language enough to speak it."
	design_unlocks = list(/datum/research_design/language_learner_sangheili)
	tech_req_all = list(\
		/datum/techprint/sangheili_translators,\
		/datum/techprint/biology_three)
	ticks_max = 120
