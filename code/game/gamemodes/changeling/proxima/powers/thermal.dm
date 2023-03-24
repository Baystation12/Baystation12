/mob/proc/changeling_thermvision()
	set category = "Changeling"
	set name = "Toggle Thermal vision"
	set desc = "Stealthly switches our vision on thermal plane... We'll see the pray throught walls."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)	return 0

	var/mob/living/carbon/human/C = src
	var/obj/item/organ/internal/eyes/eyes = C.internal_organs_by_name[BP_EYES]
	if(!C.stop_sight_update)
		C.stop_sight_update = 1
		eyes.innate_flash_protection = FLASH_PROTECTION_VULNERABLE
		C.set_sight(sight|SEE_MOBS)
		C.set_see_in_dark(8)
		C.change_light_colour(DARKTINT_GOOD)
	else
		eyes.innate_flash_protection = 0
		C.stop_sight_update = 0

	if(!C.stop_sight_update)
		to_chat(C, SPAN_LING("We return to normal."))
	else
		to_chat(C, SPAN_LING("Our eyes were... Modificated."))

	spawn(0)
		while(C.stop_sight_update && C.mind?.changeling)
			C.mind.changeling.chem_charges = max(C.mind.changeling.chem_charges - 1.6, 0)
			sleep(40)

	src.verbs -= /mob/proc/changeling_thermvision
	spawn(5)	src.verbs += /mob/proc/changeling_thermvision
	return 1
