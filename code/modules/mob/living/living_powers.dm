/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if (layer != 2.45)
		layer = 2.45 //Just above cables with their 2.44
		src << text("\blue You are now hiding.")
	else
		layer = MOB_LAYER
		src << text("\blue You have stopped hiding.")