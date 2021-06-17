/obj/item/farmbot_arm_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/mob/bot/farmbot.dmi'
	icon_state = "water_arm"
	w_class = ITEM_SIZE_NORMAL
	var/obj/tank

/obj/item/farmbot_arm_assembly/Initialize(var/ml, var/theTank)
	. = ..()
	if(!theTank)
		theTank = new /obj/structure/reagent_dispensers/watertank
	tank = theTank
	tank.forceMove(src)

/decl/crafting_stage/farmbot_begin
	progress_message = "You attach a plant scanner to the water tank."
	begins_with_object_type = /obj/item/farmbot_arm_assembly
	completion_trigger_type = /obj/item/device/scanner/plant
	next_stages = list(/decl/crafting_stage/farmbot_bucket)
	item_icon_state = "farmbot_1"

/decl/crafting_stage/farmbot_bucket
	progress_message = "You attach the bucket to the assembly."
	completion_trigger_type = /obj/item/reagent_containers/glass/bucket
	next_stages = list(/decl/crafting_stage/farmbot_minihoe)
	item_icon_state = "farmbot_1"

/decl/crafting_stage/farmbot_minihoe
	progress_message = "You attach the minihoe to the assembly."
	completion_trigger_type = /obj/item/material/minihoe
	next_stages = list(/decl/crafting_stage/proximity/farmbot)
	item_icon_state = "farmbot_1"

/decl/crafting_stage/proximity/farmbot
	progress_message = "You attach the proximity sensor and finish off the Farmbot. Beep boop."
	product = /mob/living/bot/farmbot
