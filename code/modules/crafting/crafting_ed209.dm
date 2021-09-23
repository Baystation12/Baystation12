/decl/crafting_stage/material/ed209_start
	stack_consume_amount = 5
	stack_material = MATERIAL_STEEL
	begins_with_object_type = /obj/item/robot_parts/robot_suit
	next_stages = list(/decl/crafting_stage/ed209_legs)
	progress_message = "You bulk out the robotic frame with the steel sheets."
	item_icon_state = "ed209_1"

/decl/crafting_stage/material/ed209_start/can_begin_with(obj/item/thing)
	. = ..()
	if(.)
		var/obj/item/robot_parts/robot_suit/suit = thing
		. = !length(suit.parts)

/decl/crafting_stage/ed209_legs
	completion_trigger_type = /obj/item/robot_parts
	progress_message = "You fit the frame with a right leg."
	item_icon_state = "ed209_2"
	next_stages = list(/decl/crafting_stage/ed209_legs/left)

/decl/crafting_stage/ed209_legs/is_appropriate_tool(var/obj/item/thing)
	. = istype(thing, /obj/item/robot_parts/l_leg) || istype(thing, /obj/item/robot_parts/r_leg)

/decl/crafting_stage/ed209_legs/left
	progress_message = "You fit the frame with a left leg."
	item_icon_state = "ed209_3"
	next_stages = list(/decl/crafting_stage/ed209_armour)

/decl/crafting_stage/ed209_armour
	completion_trigger_type = /obj/item/clothing/accessory/armorplate
	progress_message = "You layer the armour plating over the frame."
	item_icon_state = "ed209_4"
	next_stages = list(/decl/crafting_stage/welding/ed209)

/decl/crafting_stage/welding/ed209
	progress_message = "You weld the armour to the frame."
	next_stages = list(/decl/crafting_stage/ed209_helmet)
	item_icon_state = "ed209_4"

/decl/crafting_stage/ed209_helmet
	progress_message = "You add the helmet to the frame."
	next_stages = list(/decl/crafting_stage/ed209_proximity)
	completion_trigger_type = /obj/item/clothing/head/helmet
	item_icon_state = "ed209_5"

/decl/crafting_stage/ed209_proximity
	progress_message = "You add the proximity sensor to the frame."
	next_stages = list(/decl/crafting_stage/wiring/ed209)
	item_icon_state = "ed209_6"

/decl/crafting_stage/wiring/ed209
	progress_message = "You wire the frame together."
	stack_consume_amount = 1
	next_stages = list(/decl/crafting_stage/ed209_taser)
	item_icon_state = "ed209_6"

/decl/crafting_stage/ed209_taser
	progress_message = "You add the taser to the frame."
	next_stages = list(/decl/crafting_stage/screwdriver/ed209)
	completion_trigger_type = /obj/item/gun/energy/taser
	item_icon_state = "ed209_7"

/decl/crafting_stage/screwdriver/ed209
	progress_message = "You secure the taser in place."
	next_stages = list(/decl/crafting_stage/ed209_cell)
	item_icon_state = "ed209_7"

/decl/crafting_stage/ed209_cell
	progress_message = "You complete the ED209."
	product = /mob/living/bot/secbot/ed209
	completion_trigger_type = /obj/item/cell
