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

/datum/stack_recipe/roller_rack
	title = "roller bed rack"
	result_type = /obj/structure/roller_rack
	req_amount = 2
	time = 40
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/missile_frame
	title = "missile frame"
	result_type = /obj/structure/missile
	req_amount = 20
	time = 50
	on_floor = 1
	difficulty = 3
