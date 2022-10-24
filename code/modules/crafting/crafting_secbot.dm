/singleton/crafting_stage/secbot_signaller
	begins_with_object_type = /obj/item/clothing/head/helmet
	completion_trigger_type = /obj/item/device/assembly/signaler
	progress_message = "You add the signaler to the helmet."
	item_icon_state = "secbot_1"
	next_stages = list(/singleton/crafting_stage/welding/secbot)

/singleton/crafting_stage/secbot_signaller/can_begin_with(obj/item/thing)
	. = istype(thing) && thing.type == begins_with_object_type

/singleton/crafting_stage/welding/secbot
	progress_message = "You weld a hole into the front of the assembly."
	item_icon_state = "secbot_2"
	next_stages = list(/singleton/crafting_stage/proximity/secbot)

/singleton/crafting_stage/proximity/secbot
	progress_message = "You add the proximity sensor to the assembly."
	item_icon_state = "secbot_3"
	next_stages = list(/singleton/crafting_stage/robot_arms/secbot)

/singleton/crafting_stage/robot_arms/secbot
	item_icon_state = "secbot_4"
	next_stages = list(/singleton/crafting_stage/secbot_baton)

/singleton/crafting_stage/secbot_baton
	completion_trigger_type = /obj/item/melee/baton
	progress_message = "You complete the Securitron! Beep boop."
	product = /mob/living/bot/secbot
