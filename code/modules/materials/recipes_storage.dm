
/datum/stack_recipe/box/box
	title = "box"
	result_type = /obj/item/weapon/storage/box

/datum/stack_recipe/box/large
	title = "large box"
	result_type = /obj/item/weapon/storage/box/large
	req_amount = 2

/datum/stack_recipe/box/donut
	title = "donut box"
	result_type = /obj/item/weapon/storage/box/donut/empty

/datum/stack_recipe/box/egg
	title = "egg box"
	result_type = /obj/item/weapon/storage/fancy/egg_box/empty

/datum/stack_recipe/box/light_tubes
	title = "light tubes box"
	result_type = /obj/item/weapon/storage/box/lights/tubes/empty

/datum/stack_recipe/box/light_bulbs
	title = "light bulbs box"
	result_type = /obj/item/weapon/storage/box/lights/bulbs/empty

/datum/stack_recipe/box/mouse_traps
	title = "mouse traps box"
	result_type = /obj/item/weapon/storage/box/mousetraps/empty

/datum/stack_recipe/box/pizza
	title = "pizza box"
	result_type = /obj/item/pizzabox

/datum/stack_recipe/bag
	title = "bag"
	result_type = /obj/item/weapon/storage/bag/plasticbag
	req_amount = 3
	on_floor = 1

/datum/stack_recipe/folder
	title = "folder"
	result_type = /obj/item/weapon/folder
	var/modifier = "grey"

/datum/stack_recipe/folder/display_name()
	return "[modifier] [title]"

/datum/stack_recipe/folder/normal

#define COLORED_FOLDER(color) /datum/stack_recipe/folder/##color{\
	result_type = /obj/item/weapon/folder/##color;\
	modifier = #color\
	}
COLORED_FOLDER(blue)
COLORED_FOLDER(red)
COLORED_FOLDER(white)
COLORED_FOLDER(yellow)
#undef COLORED_FOLDER