/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(incapacitated())
		return

	if (plane != HIDING_MOB_PLANE)
		plane = HIDING_MOB_PLANE
		layer = HIDING_MOB_LAYER
		to_chat(src, "<span class='notice'>You are now hiding.</span>")
	else
		reset_plane_and_layer()
		to_chat(src, "<span class='notice'>You have stopped hiding.</span>")
