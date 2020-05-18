/decl/crafting_stage/secbot_signaller
	begins_with_object_type = /obj/item/clothing/head/helmet
	completion_trigger_type = /obj/item/device/assembly/signaler
	progress_message = "You add the signaler to the helmet."
	item_icon_state = "secbot_1"
	next_stages = list(/decl/crafting_stage/welding/secbot)

/decl/crafting_stage/secbot_signaller/can_begin_with(var/obj/item/thing)
	. = istype(thing) && thing.type == begins_with_object_type

/decl/crafting_stage/welding/secbot
	progress_message = "You weld a hole into the front of the assembly."
	item_icon_state = "secbot_2"
	next_stages = list(/decl/crafting_stage/proximity/secbot)

/decl/crafting_stage/proximity/secbot
	progress_message = "You add the proximity sensor to the assembly."
	item_icon_state = "secbot_3"
	next_stages = list(/decl/crafting_stage/robot_arms/secbot)

/decl/crafting_stage/robot_arms/secbot
	item_icon_state = "secbot_4"
	next_stages = list(/decl/crafting_stage/secbot_baton)

/decl/crafting_stage/secbot_baton
	completion_trigger_type = /obj/item/weapon/melee/baton
	progress_message = "You complete the Securitron! Beep boop."
	product = /mob/living/bot/secbot
