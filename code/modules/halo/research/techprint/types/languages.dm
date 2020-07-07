
/datum/techprint/language
	category_type = /datum/techprint/language
	desc = "Enough of the intricacies of a spoken alien language to enable conversation."
	ticks_max = 10

/datum/techprint/language/sangheili
	name = "Language: Sangheili"
	design_unlocks = list(/datum/research_design/language_learner_sangheili, /datum/research_design/implant_sangheili)
	tech_req_all = list(/datum/techprint/autopsy/sangheili)
	tech_req_one = list(\
		/datum/techprint/autopsy/jiralhanae,\
		/datum/techprint/autopsy/ruuhtian,\
		/datum/techprint/autopsy/tvoan,\
		/datum/techprint/autopsy/unggoy,\
		/datum/techprint/autopsy/sanshyuum,\
		/datum/techprint/autopsy/yanmee)
