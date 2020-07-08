
/obj/item/language_learner/english
	name = "English Language Learner"

/datum/research_design/language_learner_english
	name = "Language learner: English"
	product_type = /obj/item/language_learner/english
	required_materials = list("diamond" = 1, "uranium" = 1)
	required_objs = list(/obj/item/dumb_ai_chip = "dumb AI chip")
	build_type = PROTOLATHE
	complexity = 30

/obj/item/language_learner/sangheili
	name = "Sangheili Language Learner"
	language_string = "Sangheili"

/datum/research_design/language_learner_sangheili
	name = "Language learner: Sangheili"
	product_type = /obj/item/language_learner/sangheili
	required_materials = list("diamond" = 1, "uranium" = 1)
	required_objs = list(/obj/item/dumb_ai_chip = "dumb AI chip")
	build_type = PROTOLATHE
	complexity = 30
