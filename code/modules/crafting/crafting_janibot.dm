/decl/crafting_stage/proximity/janibot
	begins_with_object_type = /obj/item/weapon/reagent_containers/glass/bucket
	progress_message = "You put the proximity sensor into the bucket."
	item_icon_state = "janibot_1"
	next_stages = list(/decl/crafting_stage/robot_arms/janibot)

/decl/crafting_stage/robot_arms/janibot
	progress_message = "You attach the arm to the assembly and finish off the Janibot. Beep boop."
	product = /mob/living/bot/cleanbot
