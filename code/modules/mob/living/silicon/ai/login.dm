/mob/living/silicon/ai/Login()
	..()
	if (stat != DEAD)
		for (var/obj/machinery/ai_status_display/O as anything in MACHINES_OF(/obj/machinery/ai_status_display))
			O.mode = 1
			O.emotion = "Neutral"
