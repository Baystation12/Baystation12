/mob/living/silicon/ai/Login()
	..()
	if (stat != DEAD)
		for (var/obj/machinery/ai_status_display/O in SSmachines.machinery)
			O.mode = 1
			O.emotion = "Neutral"
