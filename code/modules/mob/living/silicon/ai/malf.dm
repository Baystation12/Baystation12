// Shows capacitor charge and hardware integrity information to the AI in Status tab.
/mob/living/silicon/ai/show_system_integrity()
	if(!src.stat)
		stat("Hardware integrity", "[hardware_integrity()]%")
	else
		stat("Systems nonfunctional")

