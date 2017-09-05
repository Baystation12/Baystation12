/mob/living/silicon/decoy/death(gibbed, deathmessage, show_dead_message)
	if(stat == DEAD)	return
	icon_state = "ai-crash"
	spawn(10)
		explosion(loc, 3, 6, 12, 15)
	for(var/obj/machinery/ai_status_display/O in world) //change status
		O.mode = 2
	return ..(gibbed, deathmessage, "You have suffered a critical system failure, and are dead.")