/mob/living/silicon/robot/drone/huradrone
	name = "Huragok"
	real_name = "Huragok"
	icon = 'code/modules/halo/covenant/species/huragok/huragok.dmi'
	icon_state = "engineer"
	desc = "Gas sacs on its back enable it to float. It has a long snakelike neck and multiple tentacles extending into fine cilia."
	maxHealth = 80
	health = 80
	cell_emp_mult = 0.1
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	pass_flags = PASSTABLE
	braintype = "Drone"
	lawupdate = 0
	density = 1
	req_access = list()
	integrated_light_power = 3
	local_transmit = 1
	possession_candidate = 1

	can_pull_size = ITEM_SIZE_NO_CONTAINER
	can_pull_mobs = MOB_PULL_SMALLER

//	mob_bump_flag = SIMPLE_ANIMAL
//	mob_swap_flags = SIMPLE_ANIMAL
//	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	mob_size = MOB_MEDIUM // Small mobs can't open doors, it's a huge pain for drones.

//	laws = /datum/ai_laws/huragok

/mob/living/silicon/robot/drone/huradrone/constructionHuragok
	icon = 'code/modules/halo/covenant/species/huragok/huragok.dmi'
	icon_state = "engineer"
	desc = "Gas sacs on its back enable it to float. It has a long snakelike neck and multiple tentacles extending into fine cilia."
	module_type = /obj/item/weapon/robot_module/drone/construction
	hat_x_offset = 1
	hat_y_offset = -12
	can_pull_size = ITEM_SIZE_HUGE
	can_pull_mobs = MOB_PULL_SAME

	mob_size = MOB_MEDIUM
