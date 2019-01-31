/mob/living/silicon/robot/dust()
	//Delete the MMI first so that it won't go popping out.
	if(mmi)
		qdel(mmi)
	..()

/mob/living/silicon/robot/death(gibbed,deathmessage, show_dead_message)
	if(camera)
		camera.status = 0
	if(module)
		for(var/obj/item/weapon/gripper/G in module.modules)
			G.drop_gripped_item()
	locked = 0
	remove_robot_verbs()
	..(gibbed,"shudders violently for a moment, then becomes motionless, its eyes slowly darkening.", "You have suffered a critical system failure, and are dead.")
