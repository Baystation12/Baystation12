
/mob/living/carbon/human/proc/take_flight()
	set category = "Abilities"
	set name = "Toggle Flight"
	set desc = "Toggles your flight"

	if(elevation == 0)
		visible_message("[src.name] takes flight!")
		change_elevation(1)
	else
		visible_message("[src.name] slows, then stops flapping their wings, bringing them to the ground.")
		change_elevation(-1)