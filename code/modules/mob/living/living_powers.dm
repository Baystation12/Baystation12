/mob/living/proc/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	handle_ventcrawl()

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

/spell/free/hide
	name = "Hide"
	desc = "Allows to hide beneath tables or certain items.Toggled on or off."
	spell_flags = 0

	hud_state = "alien_hide"

/spell/free/hide/choose_targets()
	return list(holder)

/spell/free/hide/cast(var/list/targets, var/mob/user)
	var/mob/target = targets[1]

	if(target.layer == 2.45)
		target.layer = MOB_LAYER
		target << "\blue You have stopped hiding."
	else
		target.layer = 2.45
		target << "\blue You are now hiding."