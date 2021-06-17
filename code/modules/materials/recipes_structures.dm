//Furniture is in a separate file.

/datum/stack_recipe/ai_core
	title = "AI core"
	result_type = /obj/structure/AIcore
	req_amount = 4
	time = 50
	one_per_turf = 1
	difficulty = 2

/datum/stack_recipe/railing
	title = "railing"
	result_type = /obj/structure/railing
	req_amount = 3
	time = 40
	on_floor = 1
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/noticeboard
	title = "noticeboard"
	result_type = /obj/structure/noticeboard
	req_amount = 10
	time = 50
	on_floor = 1
	difficulty = 2
