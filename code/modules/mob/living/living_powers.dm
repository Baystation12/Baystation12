/mob/living
	var/hiding

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(incapacitated())
		return

	hiding = !hiding
	if(hiding)
		to_chat(src, "<span class='notice'>You are now hiding.</span>")
	else
		to_chat(src, "<span class='notice'>You have stopped hiding.</span>")
	reset_layer()
