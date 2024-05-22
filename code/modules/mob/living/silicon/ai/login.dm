/mob/living/silicon/ai/Login()
	..()
	if (stat != DEAD)
		for (var/obj/machinery/ai_status_display/O as anything in SSmachines.get_machinery_of_type(/obj/machinery/ai_status_display))
			O.mode = 1
			O.emotion = "Neutral"
