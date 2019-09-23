/decl/crafting_stage/empty_storage/medibot
	begins_with_object_type = /obj/item/weapon/storage/firstaid
	progress_message = "You prop the health scanner up on the first aid kit."
	completion_trigger_type = /obj/item/device/scanner/health
	item_icon_state = "medibot_1"
	next_stages = list(/decl/crafting_stage/proximity/medibot)

/decl/crafting_stage/proximity/medibot
	progress_message = "You attach the proximity sensor and finish off the Medibot. Beep boop."
	product = /mob/living/bot/medbot

/decl/crafting_stage/proximity/medibot/get_product(obj/item/work)
	. = ..()
	if(istype(., /mob/living/bot/medbot))
		var/mob/living/bot/medbot/bot = .
		var/obj/item/weapon/storage/firstaid/kit = locate() in work
		if(bot && kit)
			bot.skin = kit.icon_state
			bot.update_icon()
