//Recipes that produce items which aren't stacks or storage.

/datum/stack_recipe/baseball_bat
	title = "baseball bat"
	result_type = /obj/item/material/twohanded/baseballbat
	req_amount = 10
	time = 20
	on_floor = 1
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/bell
	title = "bell"
	result_type = /obj/item/material/bell
	req_amount = 5
	time = 20
	send_material_data = 1

/datum/stack_recipe/ashtray
	title = "ashtray"
	result_type = /obj/item/material/ashtray
	req_amount = 2
	one_per_turf = 1
	on_floor = 1
	send_material_data = 1

/datum/stack_recipe/coin
	title = "coin"
	result_type = /obj/item/material/coin
	req_amount = 2
	one_per_turf = 1
	on_floor = 1
	send_material_data = 1

/datum/stack_recipe/ring
	title = "ring"
	result_type = /obj/item/clothing/ring/material
	on_floor = 1
	send_material_data = 1

/datum/stack_recipe/lock
	title = "lock"
	result_type = /obj/item/material/lock_construct
	time = 20
	on_floor = 1
	send_material_data = 1

/datum/stack_recipe/fork
	title = "fork"
	result_type = /obj/item/material/kitchen/utensil/fork/plastic
	on_floor = 1
	send_material_data = 1

/datum/stack_recipe/knife
	title = "table knife"
	result_type = /obj/item/material/knife/table
	on_floor = 1
	difficulty = 2
	send_material_data = 1

/datum/stack_recipe/spoon
	title = "spoon"
	result_type = /obj/item/material/kitchen/utensil/spoon/plastic
	on_floor = 1
	send_material_data = 1

/datum/stack_recipe/blade
	title = "knife"
	result_type = /obj/item/material/butterflyblade
	req_amount = 6
	time = 20
	on_floor = 1
	difficulty = 1
	send_material_data = 1

/datum/stack_recipe/grip
	title = "knife grip"
	result_type = /obj/item/material/butterflyhandle
	req_amount = 4
	time = 20
	on_floor = 1
	difficulty = 1
	send_material_data = 1

/datum/stack_recipe/key
	title = "key"
	result_type = /obj/item/key
	time = 10
	on_floor = 1

/datum/stack_recipe/cannon
	title = "cannon frame"
	result_type = /obj/item/cannonframe
	req_amount = 10
	time = 15
	difficulty = 3

/datum/stack_recipe/grenade
	title = "grenade casing"
	result_type = /obj/item/grenade/chem_grenade
	difficulty = 3

/datum/stack_recipe/light
	title = "light fixture frame"
	result_type = /obj/item/frame/light
	req_amount = 2
	difficulty = 2

/datum/stack_recipe/light_small
	title = "small light fixture frame"
	result_type = /obj/item/frame/light/small
	difficulty = 2

/datum/stack_recipe/light_large
	title = "large light fixture frame"
	result_type = /obj/item/frame/light/spot
	req_amount = 3
	difficulty = 3

/datum/stack_recipe/light_switch
	title = "light switch"
	result_type = /obj/item/frame/light_switch
	req_amount = 1
	difficulty = 2

/datum/stack_recipe/light_switch/windowtint
	title = "window tint switch"
	result_type = /obj/item/frame/light_switch/windowtint
	req_amount = 1
	difficulty = 2

/datum/stack_recipe/apc
	title = "APC frame"
	result_type = /obj/item/frame/apc
	req_amount = 2
	difficulty = 2

/datum/stack_recipe/air_alarm
	title = "air alarm frame"
	result_type = /obj/item/frame/air_alarm
	req_amount = 2
	difficulty = 2

/datum/stack_recipe/fire_alarm
	title = "fire alarm frame"
	result_type = /obj/item/frame/fire_alarm
	req_amount = 2
	difficulty = 2

/datum/stack_recipe/intercom
	title = "intercom frame"
	result_type = /obj/item/frame/intercom
	req_amount = 2
	difficulty = 2

/datum/stack_recipe/supermatter_alarm
	title = "supermatter alarm frame"
	result_type = /obj/item/frame/supermatter_alarm
	req_amount = 1
	difficulty = 2

/datum/stack_recipe/computer/telescreen
	title = "modular telescreen frame"
	result_type = /obj/item/modular_computer/telescreen
	req_amount = 10
	difficulty = 2

/datum/stack_recipe/computer/laptop
	title = "modular laptop frame"
	result_type = /obj/item/modular_computer/laptop
	req_amount = 10
	difficulty = 2

/datum/stack_recipe/computer/tablet
	title = "modular tablet frame"
	result_type = /obj/item/modular_computer/tablet
	req_amount = 5
	difficulty = 2

/datum/stack_recipe/hazard_cone
	title = "hazard cone"
	result_type = /obj/item/caution/cone
	on_floor = 1

/datum/stack_recipe/ivbag
	title = "IV bag"
	result_type = /obj/item/reagent_containers/ivbag
	req_amount = 4
	difficulty = 2

/datum/stack_recipe/cartridge
	title = "reagent dispenser cartridge"
	var/modifier = ""
	difficulty = 2

/datum/stack_recipe/cartridge/display_name()
	return "[title] ([modifier])"

/datum/stack_recipe/cartridge/small
	result_type = /obj/item/reagent_containers/chem_disp_cartridge/small
	modifier = "small"

/datum/stack_recipe/cartridge/medium
	result_type = /obj/item/reagent_containers/chem_disp_cartridge/medium
	modifier = "medium"
	req_amount = 3

/datum/stack_recipe/cartridge/large
	result_type = /obj/item/reagent_containers/chem_disp_cartridge
	modifier = "large"
	req_amount = 5

/datum/stack_recipe/sandals
	title = "sandals"
	result_type = /obj/item/clothing/shoes/sandal

/datum/stack_recipe/zipgunframe
	title = "zip gun frame"
	result_type = /obj/item/zipgunframe
	req_amount = 5
	difficulty = 3

/datum/stack_recipe/coilgun
	title = "coilgun stock"
	result_type = /obj/item/coilgun_assembly
	req_amount = 5
	difficulty = 3

/datum/stack_recipe/stick
	title = "stick"
	result_type = /obj/item/material/stick
	send_material_data = 1
	difficulty = 0

/datum/stack_recipe/shield
	title = "Buckler"
	result_type = /obj/item/shield/buckler
	req_amount = 5
	send_material_data = TRUE
	time = 20
	difficulty = 2

/datum/stack_recipe/crossbowframe
	title = "crossbow frame"
	result_type = /obj/item/crossbowframe
	req_amount = 5
	time = 25
	difficulty = 3

/datum/stack_recipe/beehive_assembly
	title = "beehive assembly"
	result_type = /obj/item/beehive_assembly
	req_amount = 4

/datum/stack_recipe/beehive_frame
	title = "beehive frame"
	result_type = /obj/item/honey_frame

/datum/stack_recipe/cardborg_suit
	title = "cardborg suit"
	result_type = /obj/item/clothing/suit/cardborg
	req_amount = 3
	difficulty = 0

/datum/stack_recipe/cardborg_helmet
	title = "cardborg helmet"
	result_type = /obj/item/clothing/head/cardborg
	difficulty = 0

/datum/stack_recipe/candle
	title = "candle"
	result_type = /obj/item/flame/candle
	difficulty = 0

/datum/stack_recipe/clipboard
	title = "clipboard"
	result_type = /obj/item/material/clipboard
	req_amount = 5
	send_material_data = 1

/datum/stack_recipe/urn
	title = "urn"
	result_type = /obj/item/material/urn
	req_amount = 5
	send_material_data = 1

/datum/stack_recipe/drill_head
	title = "drill head"
	result_type = /obj/item/material/drill_head
	req_amount = 3
	send_material_data = 1
	difficulty = 0

/datum/stack_recipe/cross
	title = "cross"
	result_type = /obj/item/material/cross
	req_amount = 2
	on_floor = 1
	send_material_data = 1
