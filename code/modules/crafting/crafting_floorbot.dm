/decl/crafting_stage/empty_storage/floorbot
	stack_consume_amount = 10
	begins_with_object_type = /obj/item/weapon/storage/toolbox
	completion_trigger_type = /obj/item/stack/tile
	progress_message = "You dump a bunch of floor tiles into the empty toolbox."
	item_icon_state = "floorbot_1"
	next_stages = list(/decl/crafting_stage/proximity/floorbot)

/decl/crafting_stage/proximity/floorbot
	progress_message = "You wedge the proximity sensor in amongst the floor tiles."
	item_icon_state = "floorbot_2"
	next_stages = list(/decl/crafting_stage/robot_arms/floorbot)

/decl/crafting_stage/robot_arms/floorbot
	progress_message = "You add the arms to the assembly to create a floorbot. Beep boop."
	product = /mob/living/bot/floorbot

/decl/crafting_stage/robot_arms/floorbot/get_product(obj/item/work)
	. = ..()
	if (istype(., /mob/living/bot/floorbot))
		var/mob/living/bot/floorbot/bot = .
		var/obj/item/weapon/storage/toolbox/box = locate() in work
		bot.boxtype = box.icon_state
		bot.update_icon()		
